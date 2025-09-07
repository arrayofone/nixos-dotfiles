{
  config,
  lib,
  pkgs,
  ...
}:
{
  fellowship.home = {
    dev.enable = true;
    dev_modules.go.enable = lib.mkForce false;
    dev_modules.flutter.enable = lib.mkForce false;
  };

  programs.zsh.envExtra = '''';

  home = {
    packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
