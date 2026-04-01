{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.spotify;
in
{
  options.${namespace}.spotify = {
    enable = lib.mkEnableOption "enable spotify";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        spotify
      ];
    };
  };
}
