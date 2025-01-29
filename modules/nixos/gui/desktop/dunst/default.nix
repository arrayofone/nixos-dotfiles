{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.desktop.dunst;
in
{
  options.${namespace}.gui.desktop.dunst = {
    enable = lib.mkEnableOption "dunst";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.dunst = {
      enable = true;
    };
  };
}