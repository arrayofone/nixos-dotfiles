{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.dbeaver;
in
{
  options.${namespace}.gui.programs.dbeaver = {
    enable = lib.mkEnableOption "enable dbeaver";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        dbeaver-bin
      ];
    };
  };
}
