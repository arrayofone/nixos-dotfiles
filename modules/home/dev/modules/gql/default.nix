{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.home.dev_modules.gql;
in
{
  options.${namespace}.home.dev_modules.gql = {
    enable = lib.mkEnableOption "enable gql features";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        graphql-language-service-cli
      ];
    };
  };
}
