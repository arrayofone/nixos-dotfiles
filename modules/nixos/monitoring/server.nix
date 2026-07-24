{ lib, config, namespace, pkgs, ... }:
let
  cfg = config.${namespace}.monitoring;

  nodeExporterDashboard = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
    hash = "sha256-1DE1aaanRHHeCOMWDGdOS1wBXxOF84UXAjJzT5Ek6mM=";
  };
  nvidiaDashboard = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/14574/revisions/4/download";
    hash = "sha256-P2klydQSVc+P5RBBXE+OS4D1D0nJzC49gQYI//qTaZ8=";
  };
  # nvidia ships "${DS_PROMETHEUS}" input placeholders; node-exporter-full uses "${datasource}"
  # template vars that resolve via the isDefault datasource. Pin placeholders AND the legacy
  # hard-coded "000000001" row uids to our uid so future revision bumps can't dangle.
  dashboardsDir = pkgs.runCommand "grafana-dashboards" { } ''
    mkdir -p $out
    sed -e 's/''${DS_PROMETHEUS}/prometheus/g' -e 's/"000000001"/"prometheus"/g' ${nodeExporterDashboard} > $out/node-exporter-full.json
    sed -e 's/''${DS_PROMETHEUS}/prometheus/g' -e 's/"000000001"/"prometheus"/g' ${nvidiaDashboard}       > $out/nvidia-gpu.json
  '';
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

    services.loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        server = {
          http_listen_address = "0.0.0.0";
          http_listen_port = 3100;
          grpc_listen_address = "127.0.0.1";
        };
        common = {
          replication_factor = 1;
          path_prefix = "/var/lib/loki";
          ring = {
            kvstore.store = "inmemory";
            instance_addr = "127.0.0.1";
          };
        };
        schema_config.configs = [
          {
            from = "2026-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = { prefix = "index_"; period = "24h"; };
          }
        ];
        storage_config.filesystem.directory = "/var/lib/loki/chunks";
        compactor = {
          working_directory = "/var/lib/loki/compactor";
          retention_enabled = true;
          delete_request_store = "filesystem";
        };
        limits_config.retention_period = cfg.server.logRetention;
      };
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = cfg.server.grafanaPort;
        };
        analytics.reporting_enabled = false;
        # nixpkgs 26.05 removed the default for security.secret_key (was previously implicit).
        # Neither provisioned datasource carries credentials, so there is nothing in the DB
        # yet that this key protects; using the documented legacy default is upstream's own
        # zero-risk path for that case. Before storing any datasource secrets in Grafana,
        # replace this with a generated key via a file-provider (e.g. sops-nix), since keys
        # cannot be rotated without re-encrypting existing secrets.
        security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            uid = "prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:9090";
            isDefault = true;
          }
          {
            name = "Loki";
            uid = "loki";
            type = "loki";
            url = "http://127.0.0.1:3100";
          }
        ];
        dashboards.settings.providers = [
          {
            name = "vendored";
            options.path = dashboardsDir;
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.server.grafanaPort 3100 ];
  };
}
