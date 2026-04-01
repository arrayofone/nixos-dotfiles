{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.librewolf;
in
{
  options.${namespace}.librewolf = {
    enable = lib.mkEnableOption "enable librewolf";
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf.enable = true;
  };
}