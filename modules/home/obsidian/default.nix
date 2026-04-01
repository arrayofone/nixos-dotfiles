{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.obsidian;
in
{
  options.${namespace}.obsidian = {
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
