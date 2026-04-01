{lib, pkgs, config, namespace, ...}:
let
    cfg = config.${namespace}.postman;
in
{
  options.${namespace}.postman = {
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
