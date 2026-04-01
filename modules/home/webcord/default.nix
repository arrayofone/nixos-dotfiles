{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.webcord;
in
{
  options.${namespace}.webcord = {
    enable = lib.mkEnableOption "enable webcord";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        webcord
      ];
    };
  };
}
