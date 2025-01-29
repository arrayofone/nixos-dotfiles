{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.home.dev_modules.go;
in
{
  # imports =
  #   [ ]
  #   ++ lib.optionals cfg.enable [
  #     ./golangci-lint.nix
  #   ];

  options.${namespace}.home.dev_modules.go = {
    enable = lib.mkEnableOption "enable go";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        delve
        go_1_24
        go-ethereum
        gopls
        gotools
        go-tools
        # golangci-lint
      ];
    };
  };
}
