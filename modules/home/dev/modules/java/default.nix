{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.home.dev_modules.java;
in
{
  options.${namespace}.home.dev_modules.java = {
    jdk21.enable = lib.mkEnableOption "enable java";
    temurin.enable = lib.mkEnableOption "enable temurin java";
  };

  config = {
    home = {
      packages =
        with pkgs;
        lib.optionals cfg.jdk21.enable [ jdk21_headless ]
        ++ lib.optionals cfg.temurin.enable [ temurin-bin ];
    };
  };
}
