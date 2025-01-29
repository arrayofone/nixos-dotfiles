{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.gparted;
in
{
  options.${namespace}.gui.programs.gparted = {
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
