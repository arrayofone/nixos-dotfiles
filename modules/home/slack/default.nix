{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.slack;
in
{
  options.${namespace}.slack = {
    enable = lib.mkEnableOption "enable slack";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        slack
      ];
    };
  };
}
