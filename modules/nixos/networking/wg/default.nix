{
  lib,
  config,
  namespace,
  ...
}:
{
  options.${namespace}.networking.wireguard.server = {
    enable = lib.mkEnableOption "enable wireguard server";
    externalInterface = lib.mkOption {
      description = "External facing interface";
      type = lib.types.string;
    };
    interface = lib.mkOption {
      description = "WireGuard interface name";
      type = lib.types.string;
      default = "wg0";
    };
    port = lib.mkOption {
      description = "UDP port for WireGuard";
      type = lib.types.port;
    };
    ips = lib.mkOption {
      description = "IP addresses and subnets for the WireGuard interface";
      type = lib.types.listOf lib.types.string;
      default = [ "10.20.0.2/24" ];
    };
    privateKeyFile = lib.mkOption {
      description = "Path to the private key file";
      type = lib.types.nullOr lib.types.path;
    };
    routes = lib.mkOption {
      description = "Additional routes to configure";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            destination = lib.mkOption {
              description = "Route destination";
              type = lib.types.string;
            };
            via = lib.mkOption {
              description = "Route gateway";
              type = lib.types.string;
            };
            dev = lib.mkOption {
              description = "Route device";
              type = lib.types.string;
            };
          };
        }
      );
      default = [ ];
    };
    peers = lib.mkOption {
      description = "WireGuard peers configuration";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            publicKey = lib.mkOption {
              description = "Public key of the peer";
              type = lib.types.nullOr lib.types.string;
              default = null;
            };
            allowedIPs = lib.mkOption {
              description = "Allowed IP addresses for this peer";
              type = lib.types.listOf lib.types.string;
              default = [ "0.0.0.0/0" ];
            };
            endpoint = lib.mkOption {
              description = "Endpoint address and port";
              type = lib.types.nullOr lib.types.string;
            };
            persistentKeepalive = lib.mkOption {
              description = "Keepalive interval in seconds";
              type = lib.types.nullOr lib.types.int;
              default = 25;
            };
          };
        }
      );
      default = [ { } ];
    };
  };

  config = lib.mkIf config.${namespace}.networking.wireguard.server.enable {
    # enable NAT
    # networking.nat.enable = true;
    # networking.nat.externalInterface =
    #   config.${namespace}.networking.wireguard.server.externalInterface; # "enp42s0"
    # networking.nat.internalInterfaces = [ "wg0" ];
    networking.firewall = {
      enable = lib.mkForce false;
      allowedUDPPorts = [ config.${namespace}.networking.wireguard.server.port ];
    };

    networking.wg-quick.interfaces = {
      ${config.${namespace}.networking.wireguard.server.interface} = {

        address = config.${namespace}.networking.wireguard.server.ips;
        dns = [ "9.9.9.9" ];
        privateKeyFile = config.${namespace}.networking.wireguard.server.privateKeyFile;

        peers = map (
          peer:
          {
            publicKey = peer.publicKey;
            allowedIPs = peer.allowedIPs;
            endpoint = peer.endpoint;
            persistentKeepalive = peer.persistentKeepalive;
          }
          // lib.optionalAttrs (peer.publicKey != null) { inherit (peer) publicKey; }
          // lib.optionalAttrs (peer.endpoint != null) { inherit (peer) endpoint; }
          // lib.optionalAttrs (peer.persistentKeepalive != null) { inherit (peer) persistentKeepalive; }
        ) config.${namespace}.networking.wireguard.server.peers;
      };
    };
  };
}
