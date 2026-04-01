{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.element;
in
{
  options.${namespace}.element = {
    enable = lib.mkEnableOption "enable element";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        element-desktop
      ];
    };
  };
}
