{lib, pkgs, config, namespace, ...}:
let
    cfg = config.${namespace}.firefox;
in
{
  options.${namespace}.firefox = {
    enable = lib.mkEnableOption "enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}