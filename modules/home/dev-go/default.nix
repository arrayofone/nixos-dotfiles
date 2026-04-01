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
        go_1_25
        go-ethereum
        gopls
        gotools
        go-tools
        # golangci-lint
      ];
    };
  };
}
