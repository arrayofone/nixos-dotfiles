{lib, pkgs, config, namespace, ...}: 
let
    cfg = config.${namespace}.gui.programs.firefox;
in
{
  options.${namespace}.gui.programs.firefox = {
    enable = lib.mkEnableOption "enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}