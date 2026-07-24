{ lib, config, namespace, ... }:
let
  cfg = config.${namespace}.monitoring;
in
{
  imports = [ ./server.nix ];

  options.${namespace}.monitoring = {
    agent = {
      enable = lib.mkEnableOption "node-level metrics + journal shipping (node_exporter + alloy)";

      lokiUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "http://10.0.30.2:3100";
        description = "Loki base URL to ship the journal to; null disables log shipping.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Open the node_exporter port (9100) so the monitoring server can scrape.";
      };
    };

    server = {
      enable = lib.mkEnableOption "monitoring server (Prometheus + Loki + Grafana + host exporters)";

      grafanaPort = lib.mkOption {
        type = lib.types.port;
        default = 3000;
      };

      metricsRetention = lib.mkOption {
        type = lib.types.str;
        default = "365d";
        description = "Prometheus TSDB retention.";
      };

      logRetention = lib.mkOption {
        type = lib.types.str;
        default = "2160h"; # 90d; Loki takes hours
        description = "Loki log retention (compactor-enforced).";
      };

      nodeTargets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "10.0.30.11:9100" ];
        description = "node_exporter scrape targets beyond localhost (host:port).";
      };
    };
  };

  config = lib.mkIf cfg.agent.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" "processes" ];
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.agent.openFirewall [ 9100 ];

    services.alloy.enable = cfg.agent.lokiUrl != null;

    # alloy runs with DynamicUser; journal read requires the group
    systemd.services.alloy.serviceConfig.SupplementaryGroups =
      lib.mkIf (cfg.agent.lokiUrl != null) [ "systemd-journal" ];

    environment.etc."alloy/config.alloy" = lib.mkIf (cfg.agent.lokiUrl != null) {
      text = ''
        loki.relabel "journal" {
          forward_to = []
          rule {
            source_labels = ["__journal__systemd_unit"]
            target_label  = "unit"
          }
          rule {
            source_labels = ["__journal__transport"]
            target_label  = "transport"
          }
          rule {
            source_labels = ["__journal_priority_keyword"]
            target_label  = "level"
          }
        }

        loki.source.journal "journal" {
          relabel_rules = loki.relabel.journal.rules
          forward_to    = [loki.write.default.receiver]
          labels        = {job = "systemd-journal", host = "${config.networking.hostName}"}
        }

        loki.write.default {
          endpoint {
            url = "${cfg.agent.lokiUrl}/loki/api/v1/push"
          }
        }
      '';
    };
  };
}
