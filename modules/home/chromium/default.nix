{lib, pkgs, config, namespace, ...}:
let
    cfg = config.${namespace}.chromium;
in
{
  options.${namespace}.chromium = {
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