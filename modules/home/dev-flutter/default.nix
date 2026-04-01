{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.dev-flutter;
in
{
  options.${namespace}.dev-flutter = {
    enable = lib.mkEnableOption "enable flutter tooling";
  };

  config = lib.mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = pkgs.temurin-bin-21;
    };

    home = {
      sessionVariables = {
        CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
        GOOGLE_APPLICATION_CREDENTIALS = "~/myGoogleCreds.json";
      };

      packages = with pkgs; [
        flutter
        firebase-tools
        android-studio
        android-tools
        temurin-bin-21
      ];
    };
  };
}
