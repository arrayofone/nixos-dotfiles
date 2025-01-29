{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.webcord;
in
{
  options.${namespace}.gui.programs.webcord = {
    enable = lib.mkEnableOption "enable webcord";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        webcord
      ];
    };
  };
}
