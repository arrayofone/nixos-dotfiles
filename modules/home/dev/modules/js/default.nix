{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.home.dev_modules.js;
in
{
  options.${namespace}.home.dev_modules.js = {
    enable = lib.mkEnableOption "enable javascript";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        deno
        nodejs
        pnpm
        typescript
        yarn
      ];
    };
  };
}
