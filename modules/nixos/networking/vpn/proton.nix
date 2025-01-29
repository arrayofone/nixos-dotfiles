{ pkgs, ... }:{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wg-quick.interfaces = {
    wg-proton = {
      listenPort = 51820;
      address = [ "10.2.0.2/32" ];
      # dns = [ "10.2.0.1" ];
      privateKeyFile = "/home/arrayofone/vpn/proton-wireguard-CA-500.priv";

      peers = [
        {
          publicKey = "WajeJDezN7JFBe//v/VMsASFyBUk01Hlyvjb0T+dTjE=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "79.127.254.92:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}