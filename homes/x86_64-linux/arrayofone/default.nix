{ pkgs, ... }:
let
  # nixosVSCodeServer = {
  #   url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
  #   sha256 = "1rdn70jrg5mxmkkrpy2xk8lydmlc707sk0zb35426v1yxxka10by";
  # };
in
{
  imports = [
    # "${fetchTarball nixosVSCodeServer}/modules/vscode-server/home.nix"
  ];

  services = {
    # vscode-server.enable = false;
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };

  fellowship = {
    dunst.enable = true;
    hypridle.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    waybar.enable = true;

    brave.enable = true;
    firefox.enable = true;
    librewolf.enable = false;
    dbeaver.enable = true;
    element.enable = true;
    gparted.enable = true;
    obsidian.enable = true;
    postman.enable = true;
    slack.enable = true;
    tidal.enable = true;
    webcord.enable = true;

    dev.enable = true;
  };

  home = {
    packages = with pkgs; [
      bibata-cursors
      clipse
      fontconfig
      neofetch
      papirus-icon-theme
      pinentry-curses
    ];

    stylix = {
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 32;
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };
    };

    stateVersion = "24.05";
  };
}
