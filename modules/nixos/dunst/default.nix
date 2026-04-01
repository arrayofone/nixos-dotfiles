{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.dunst;
in
{
  options.${namespace}.dunst = {
    enable = lib.mkEnableOption "dunst";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.dunst = {
      enable = true;
    };
  };
}
