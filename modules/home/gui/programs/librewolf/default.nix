{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.gui.programs.librewolf;
in
{
  options.${namespace}.gui.programs.librewolf = {
    enable = lib.mkEnableOption "enable librewolf";
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf.enable = true;
  };
}