{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.dev-gql;
in
{
  options.${namespace}.dev-gql = {
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
