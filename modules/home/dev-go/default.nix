{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.dev-go;
in
{
  options.${namespace}.dev-go = {
    enable = lib.mkEnableOption "enable go";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        delve
        go_1_26
        go-ethereum
        gopls
        (lib.meta.lowPrio gotools)
        go-tools
        # golangci-lint
      ];
    };
  };
}
