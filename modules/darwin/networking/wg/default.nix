# @gitian:module WireGuard VPN module — cross-platform (darwin + nixos) VPN client
# using wg-quick. Peers, keys, and endpoints are configured via module options;
# the private key file path comes from SOPS-decrypted secrets.
{
  lib,
  config,
  namespace,
  ...
}:
{
  options.${namespace}.networking.wireguard.server = {
    enable = lib.mkEnableOption "enable wireguard server";
    dns = lib.mkOption {
      description = "DNS addresses for the wireguard interface";
      type = lib.types.listOf lib.types.str;
      default = [ "1.1.1.1" ];
    };
    mtu = lib.mkOption {
      description = "MTU for the wireguard interface";
      type = lib.types.nullOr lib.types.int;
      default = null;
    };
    interface = lib.mkOption {
      description = "WireGuard interface name";
      type = lib.types.str;
      default = "wg0";
    };
    ips = lib.mkOption {
      description = "IP addresses and subnets for the WireGuard interface";
      type = lib.types.listOf lib.types.str;
      default = [ "10.20.0.2/24" ];
    };
    privateKeyFile = lib.mkOption {
      description = "Path to the private key file";
      type = lib.types.nullOr lib.types.path;
    };
    peers = lib.mkOption {
      description = "WireGuard peers configuration";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            publicKey = lib.mkOption {
              description = "Public key of the peer";
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            allowedIPs = lib.mkOption {
              description = "Allowed IP addresses for this peer";
              type = lib.types.listOf lib.types.str;
              default = [ "0.0.0.0/0" ];
            };
            endpoint = lib.mkOption {
              description = "Endpoint address and port";
              type = lib.types.nullOr lib.types.str;
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

    # networking.firewall = {
    #   enable = lib.mkForce false;
    #   allowedUDPPorts = [ config.${namespace}.networking.wireguard.server.port ];
    # };

    networking.wg-quick.interfaces = {
      ${config.${namespace}.networking.wireguard.server.interface} = {
        address = config.${namespace}.networking.wireguard.server.ips;
        dns = config.${namespace}.networking.wireguard.server.dns;
        privateKeyFile = config.${namespace}.networking.wireguard.server.privateKeyFile;
      }
      // lib.optionalAttrs (config.${namespace}.networking.wireguard.server.mtu != null) {
        mtu = config.${namespace}.networking.wireguard.server.mtu;
      }
      // {
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
