{lib, pkgs, config, namespace, ...}:
let
    cfg = config.${namespace}.gui.programs.postman;
in
{
  options.${namespace}.gui.programs.postman = {
    enable = lib.mkEnableOption "enable postman";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
          postman
      ];
    };
  };
}
