{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.tidal;
in
{
  options.${namespace}.tidal = {
    enable = lib.mkEnableOption "enable tidal";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        tidal-hifi
      ];
    };
  };
}
