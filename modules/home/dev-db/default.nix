{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.dev-db;
in
{
  options.${namespace}.dev-db = {
    enable = lib.mkEnableOption "enable db tooling";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        sqlc
        sqlite
        # pgcli
        # postgresql
        # mongodb
      ];
    };
  };
}
