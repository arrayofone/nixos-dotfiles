{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.desktop.waybar;
in
{
  options.${namespace}.gui.desktop.waybar = {
    enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar.enable = true;
    programs.waybar.systemd.enable = true;
    
    home = {
      packages = with pkgs; [
          waybar
          font-awesome # default icons for waybar
      ];
    };
  };
}
