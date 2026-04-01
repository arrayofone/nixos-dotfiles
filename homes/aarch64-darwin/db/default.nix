{
  config,
  lib,
  pkgs,
  ...
}:
{
  fellowship = {
    dev.enable = true;
    dev-go.enable = lib.mkForce false;
    dev-flutter.enable = lib.mkForce false;
  };

  programs.zsh.envExtra = '''';

  home = {
    packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
