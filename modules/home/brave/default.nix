{lib, pkgs, config, namespace, ...}:
let
    cfg = config.${namespace}.brave;
in
{
  options.${namespace}.brave = {
    enable = lib.mkEnableOption "enable brave";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
          brave
      ];
    };
  };
}
