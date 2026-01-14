{ pkgs, ... }:
{
  fellowship.home.dev.enable = false;

  programs.zsh.envExtra = "";

  home = {
    packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
