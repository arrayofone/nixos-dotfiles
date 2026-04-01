{ lib, config, pkgs, namespace, ... }:
let
    cfg = config.${namespace}.dbeaver;
in
{
  options.${namespace}.dbeaver = {
    enable = lib.mkEnableOption "enable dbeaver";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        dbeaver-bin
      ];
    };
  };
}
