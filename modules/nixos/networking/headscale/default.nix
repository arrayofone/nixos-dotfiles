{pkgs, lib, config, namespace, ...}: 
let domain = "headscale.${namespace}.com";
in {
  # options.${namespace}.networking.headscale = {
  #   enable = lib.mkEnableOption "enable headscale";
  #   # domain = lib.mkOption
  # };

  # config = lib.mkIf config.${namespace}.networking.headscale.enable {
  #   services = {
  #     headscale = {
  #       enable = true;
  #       address = "0.0.0.0";
  #       port = 8080;
  #       settings = { 
  #         server_url = "https://${domain}";
  #         dns = { 
  #           base_domain = "dnet"; 
  #         };
  #         logtail.enabled = false; 
  #       };
  #     };

  #     nginx.virtualHosts.${domain} = {
  #       forceSSL = true;
  #       enableACME = true;
  #       locations."/" = {
  #         proxyPass =
  #           "http://localhost:${toString config.services.headscale.port}";
  #         proxyWebsockets = true;
  #       };
  #     };
  #   };

  #   # environment.systemPackages = [ config.services.headscale.package ];
  # };
}




