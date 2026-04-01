{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.dev;
in
{
  options.${namespace}.dev = {
    enable = lib.mkEnableOption "enable dev tooling";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      dev-db.enable = false;
      dev-go.enable = true;
      dev-gql.enable = true;
      dev-js.enable = true;
      dev-flutter.enable = false;
    };
  };
}
