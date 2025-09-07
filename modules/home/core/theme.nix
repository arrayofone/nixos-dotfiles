{
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.packages = [
    pkgs.font-awesome
  ]
  ++ lib.optionals (builtins.elem system pkgs.bibata-cursors.meta.platforms) [ pkgs.bibata-cursors ]
  ++ lib.optionals (builtins.elem system pkgs.papirus-icon-theme.meta.platforms) [
    pkgs.papirus-icon-theme
  ];
  # ++ lib.mkIf (builtins.elem system pkgs.papirus-icon-theme.meta.platforms) [ ];

  stylix = {
    enable = true;

    autoEnable = true;

    opacity = {
      applications = 0.95;
      desktop = 1.0;
      popups = 0.95;
      terminal = 0.95;
    };

    base16Scheme = ./theme/base16/catppuccin/macciato.yaml;

    cursor = lib.mkIf (builtins.elem system pkgs.bibata-cursors.meta.platforms) {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };

    fonts = {
      monospace = {
        name = "IntoneMono Nerd Font Mono";
        package = lib.mkDefault pkgs.nerd-fonts.intone-mono;
      };

      sansSerif = {
        name = "UbuntuSans Nerd Font";
        package = lib.mkDefault pkgs.nerd-fonts.ubuntu-sans;
      };

      serif = {
        name = "Ubuntu Nerd Font";
        package = lib.mkDefault pkgs.nerd-fonts.ubuntu;
      };

      emoji = {
        name = "Noto Color Emoji";
        package = lib.mkDefault pkgs.noto-fonts-color-emoji;
      };

      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
        terminal = 12;
      };
    };

    iconTheme = lib.mkIf (builtins.elem system pkgs.papirus-icon-theme.meta.platforms) {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };

    # override = {
    #   base00 = "1e1e2e"; # base - Catppuccin Mocha
    #   base01 = "181825"; # mantle
    #   base02 = "313244"; # surface0
    #   base03 = "45475a"; # surface1
    #   base04 = "585b70"; # surface2
    #   base05 = "cdd6f4"; # text
    #   base06 = "f5e0dc"; # rosewater
    #   base07 = "b4befe"; # lavender
    #   base08 = "f38ba8"; # red
    #   base09 = "fab387"; # peach
    #   base0A = "f9e2af"; # yellow
    #   base0B = "a6e3a1"; # green
    #   base0C = "94e2d5"; # teal
    #   base0D = "89b4fa"; # blue
    #   base0E = "cba6f7"; # mauve
    #   base0F = "f2cdcd"; # flamingo
    # };

    image = ./theme/wallpapers/rx7.png;

    polarity = "dark";

    targets = {
      #   vscode.profileNames = [ "default" ];
      firefox.profileNames = [ "default" ];
      librewolf.profileNames = [ "default" ];
      zed.enable = false;
    };
  };
}
