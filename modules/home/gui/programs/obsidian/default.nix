{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.obsidian;
in
{
  options.${namespace}.gui.programs.obsidian = {
    enable = lib.mkEnableOption "enable obsidian";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        obsidian
      ];
    };
  };
}
