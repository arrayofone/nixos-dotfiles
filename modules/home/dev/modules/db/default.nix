{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.home.dev_modules.db;
in
{
  options.${namespace}.home.dev_modules.db = {
    enable = lib.mkEnableOption "enable db tooling";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        sqlc
        sqlite
        pgcli
        postgresql
        # mongodb
      ];
    };
  };
}
