{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.networking.bridge;
in
{
  options.${namespace}.networking.bridge = {
    enable = lib.mkEnableOption "bridge networking with DHCP and NAT";

    interface = lib.mkOption {
      description = "Bridge interface name";
      type = lib.types.str;
      default = "br0";
    };

    subnet = lib.mkOption {
      description = "Bridge subnet in CIDR notation (e.g. 10.10.0.0/24)";
      type = lib.types.str;
    };

    hostAddress = lib.mkOption {
      description = "Host IP address on the bridge (e.g. 10.10.0.1)";
      type = lib.types.str;
    };

    dhcpRange = lib.mkOption {
      description = "DHCP range for VMs";
      type = lib.types.submodule {
        options = {
          start = lib.mkOption {
            description = "Start of DHCP range";
            type = lib.types.str;
          };
          end = lib.mkOption {
            description = "End of DHCP range";
            type = lib.types.str;
          };
        };
      };
    };

    uplinkInterface = lib.mkOption {
      description = "Physical uplink interface for NAT";
      type = lib.types.str;
      default = "eth0";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.useNetworkd = true;
    systemd.network.enable = true;

    systemd.network.netdevs."10-${cfg.interface}" = {
      netdevConfig = {
        Name = cfg.interface;
        Kind = "bridge";
      };
    };

    systemd.network.networks."10-${cfg.interface}" = {
      matchConfig.Name = cfg.interface;
      networkConfig = {
        Address = [
          "${cfg.hostAddress}/${lib.last (lib.splitString "/" cfg.subnet)}"
        ];
        DHCPServer = true;
      };
      dhcpServerConfig = {
        PoolOffset = lib.toInt (lib.last (lib.splitString "." cfg.dhcpRange.start));
        PoolSize =
          (lib.toInt (lib.last (lib.splitString "." cfg.dhcpRange.end)))
          - (lib.toInt (lib.last (lib.splitString "." cfg.dhcpRange.start)))
          + 1;
        DNS = [ cfg.hostAddress ];
      };
      linkConfig.RequiredForOnline = "no";
    };

    networking.nat = {
      enable = true;
      externalInterface = cfg.uplinkInterface;
      internalInterfaces = [ cfg.interface ];
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    networking.firewall.trustedInterfaces = [ cfg.interface ];
  };
}
