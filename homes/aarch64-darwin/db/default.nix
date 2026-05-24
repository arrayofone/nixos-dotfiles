{
  config,
  lib,
  pkgs,
  ...
}:
{
  fellowship = {
    claude.enable = true;
    dev.enable = true;
    dev-go.enable = lib.mkForce false;
    dev-flutter.enable = lib.mkForce false;
    obsidian.enable = true;
  };

  programs.zsh.envExtra = '''';

  home = {
    packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
