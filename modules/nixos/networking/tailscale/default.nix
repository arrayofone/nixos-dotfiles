{pkgs, lib, config, namespace, ...}: {
  # options.${namespace}.networking.tailscale = {
  #   enable = lib.mkEnableOption "enable tailscale";
  # };

  # config = lib.mkIf config.${namespace}.networking.tailscale.enable {
  #   services.tailscale.enable = true;
  # };
}