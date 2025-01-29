{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.tidal;
in
{
  options.${namespace}.gui.programs.tidal = {
    enable = lib.mkEnableOption "enable tidal";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        tidal-hifi
      ];
    };
  };
}
