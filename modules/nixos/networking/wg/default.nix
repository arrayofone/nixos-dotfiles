{
  pkgs,
  lib,
  config,
  namespace,
  ...
}:
let
  # serverPvtKey = (builtins.readFile ./keys/server/private);
  # serverPubKey = (builtins.readFile ./keys/server/public);
  # baradurPvtKey = (builtins.readFile ./keys/baradur/private);
  # baradurPubKey = (builtins.readFile ./keys/baradur/public);
  # rollbookPvtKey = (builtins.readFile ./keys/rollbook/private);
  # rollbookPubKey = (builtins.readFile ./keys/rollbook/public);
in
{
  options.${namespace}.networking.wireguard.server = {
    enable = lib.mkEnableOption "enable wireguard server";
    externalInterface = lib.mkOption {
      description = "External facing interface";
      type = lib.types.string;
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
      allowedUDPPorts = [ 51821 ];
    };

    networking.wireguard.interfaces = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = [ "10.20.0.2/24" ];
        # Path to the private key file.
        #
        # Note: The private key can also be included inline via the privateKey option,
        # but this makes the private key world-readable; thus, using privateKeyFile is
        # recommended.
        # privateKeyFile = "${lib.snowfall.fs.get-file "modules"}/nixos/networking/wg/keys/baradur/private";

        postSetup = ''
          ip route add 3.98.30.232 via 10.10.0.1 dev enp42s0
        '';

        # # This undoes the above command
        postShutdown = ''
          ip route del 3.98.30.232 via 10.10.0.1 dev enp42s0
        '';

        peers = [
          # For a client configuration, one peer entry for the server will suffice.

          {
            # Public key of the server (not a file path).
            # publicKey = "2932qgfQczv8nX63HFB0wupQ15f8AG3lPeKCrTMHm2g=";

            allowedIPs = [ "0.0.0.0/0" ];

            # Set this to the server IP and port.
            # endpoint = "wg.arrayof.one:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
        ];
      };
      # wg1 = {
      #   # Path to the private key file.
      #   #
      #   # Note: The private key can also be included inline via the privateKey option,
      #   # but this makes the private key world-readable; thus, using privateKeyFile is
      #   # recommended.
      # privateKey = "${baradurPvtKey}";

      #   peers = [
      #     { # baradur
      #       publicKey = "${baradurPubKey}";
      #       allowedIPs = [ "10.100.0.2/32" ];
      #     }
      #   ];
      # };
      # wg2 = {
      #   # Path to the private key file.
      #   #
      #   # Note: The private key can also be included inline via the privateKey option,
      #   # but this makes the private key world-readable; thus, using privateKeyFile is
      #   # recommended.
      #   privateKey = "${rollbookPvtKey}";

      #   peers = [{ # rollbook
      #     publicKey = "${rollbookPubKey}";
      #     allowedIPs = [ "10.100.0.3/32" ];
      #   }];
      # };
    };
  };
}
