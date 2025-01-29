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
      db.enable = true;
      go.enable = true;
      gql.enable = true;
      java = {
        temurin.enable = true;
        jdk21.enable = false;
      };
      js.enable = true;
    };

    home = {
      packages = with pkgs; [
        # nixd
        parallel
      ];
    };
  };
}
