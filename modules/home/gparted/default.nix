{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.gparted;
in
{
  options.${namespace}.gparted = {
    enable = lib.mkEnableOption "enable gparted";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        gparted
      ];
    };
  };
}
