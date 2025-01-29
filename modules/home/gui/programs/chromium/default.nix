{lib, pkgs, config, namespace, ...}: 
let
    cfg = config.${namespace}.gui.programs.chromium;
in
{
  options.${namespace}.gui.programs.chromium = {
    enable = lib.mkEnableOption "enable chromium";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        chromium
      ];
    };  
  };
}