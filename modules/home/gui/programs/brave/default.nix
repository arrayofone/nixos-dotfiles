{lib, pkgs, config, namespace, ...}:
let
    cfg = config.${namespace}.gui.programs.brave;
in
{
  options.${namespace}.gui.programs.brave = {
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
