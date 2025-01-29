{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.spotify;
in
{
  options.${namespace}.gui.programs.spotify = {
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
