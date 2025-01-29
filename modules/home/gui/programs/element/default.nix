{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.element;
in
{
  options.${namespace}.gui.programs.element = {
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
