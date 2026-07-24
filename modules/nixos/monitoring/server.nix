{ lib, config, namespace, pkgs, ... }:
let
  cfg = config.${namespace}.monitoring;
in
{
  config = lib.mkIf cfg.server.enable {
    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;
      retentionTime = cfg.server.metricsRetention;

      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "15s";
      };

      exporters = {
        smartctl.enable = true;   # 9633 — NVMe/SATA health, auto-discovers devices
        nvidia-gpu.enable = true; # 9835 — wraps nvidia-smi
        systemd.enable = true;    # 9558 — per-unit states + cgroup resources

        wireguard = lib.mkIf config.${namespace}.wireguard.enable {
          enable = true;          # 9586 — per-peer handshake/transfer
        };

        blackbox = {
          enable = true;          # 9115
          configFile = pkgs.writeText "blackbox.yml" (builtins.toJSON {
            modules = {
              icmp.prober = "icmp";
              dns_quad9 = {
                prober = "dns";
                dns = {
                  query_name = "google.com";
                  query_type = "A";
                  transport_protocol = "udp";
                };
              };
            };
          });
        };
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [ { targets = [ "127.0.0.1:9100" ] ++ cfg.server.nodeTargets; } ];
        }
        { job_name = "smartctl";   static_configs = [ { targets = [ "127.0.0.1:9633" ]; } ]; }
        { job_name = "nvidia_gpu"; static_configs = [ { targets = [ "127.0.0.1:9835" ]; } ]; }
        { job_name = "systemd";    static_configs = [ { targets = [ "127.0.0.1:9558" ]; } ]; }
        { job_name = "prometheus"; static_configs = [ { targets = [ "127.0.0.1:9090" ]; } ]; }
        { job_name = "loki";       static_configs = [ { targets = [ "127.0.0.1:3100" ]; } ]; }
        {
          job_name = "blackbox_icmp";
          metrics_path = "/probe";
          params.module = [ "icmp" ];
          static_configs = [ { targets = [ "1.1.1.1" "9.9.9.9" ]; } ];
          relabel_configs = [
            { source_labels = [ "__address__" ]; target_label = "__param_target"; }
            { source_labels = [ "__param_target" ]; target_label = "instance"; }
            { target_label = "__address__"; replacement = "127.0.0.1:9115"; }
          ];
        }
        {
          job_name = "blackbox_dns";
          metrics_path = "/probe";
          params.module = [ "dns_quad9" ];
          static_configs = [ { targets = [ "9.9.9.9" ]; } ];
          relabel_configs = [
            { source_labels = [ "__address__" ]; target_label = "__param_target"; }
            { source_labels = [ "__param_target" ]; target_label = "instance"; }
            { target_label = "__address__"; replacement = "127.0.0.1:9115"; }
          ];
        }
      ]
      ++ lib.optionals config.${namespace}.wireguard.enable [
        { job_name = "wireguard"; static_configs = [ { targets = [ "127.0.0.1:9586" ]; } ]; }
      ];
    };

    # per-unit CPU/memory/IO for the systemd exporter — `systemd.enableCgroupAccounting` was
    # removed on this pinned nixpkgs (mkRemovedOptionModule, see systemd.nix); cgroup CPU/memory/
    # tasks accounting is on by default in modern systemd, and NixOS now sets
    # DefaultIOAccounting/DefaultIPAccounting = true itself, so no replacement setting is needed.
  };
}
