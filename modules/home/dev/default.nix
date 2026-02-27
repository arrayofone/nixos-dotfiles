# @gitian:option Dev tooling gate — when `fellowship.home.dev.enable = true`, activates
# language-specific sub-modules (Go, JS, GraphQL, DB, Flutter). Each sub-module has
# its own enable flag under `fellowship.home.dev_modules.<lang>.enable`.
{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.home.dev;
in
{
  options.${namespace}.home.dev = {
    enable = lib.mkEnableOption "enable dev tooling";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.home.dev_modules = {
      db.enable = false;
      go.enable = true;
      gql.enable = true;
      js.enable = true;
      flutter.enable = false;
    };

    home = {
      packages = with pkgs; [
        nixd
        parallel
      ];
    };
  };
}
