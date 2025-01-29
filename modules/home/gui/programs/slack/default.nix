{ lib, config, pkgs, namespace, ... }: 
let
    cfg = config.${namespace}.gui.programs.slack;
in
{
  options.${namespace}.gui.programs.slack = {
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
