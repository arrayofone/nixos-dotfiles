{ lib, pkgs, ... }:
{
  # fellowship.home = {
  #   dev.enable = false;
  #   programs.zeditor = {
  #     nodePath = lib.getExe pkgs.nodejs_20;
  #     npmPath = lib.getExe' pkgs.nodejs_20 "npm";
  #   };
  # };

  programs.zsh.envExtra = ''
    neofetch
  '';

  home = {
    # packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
