# @gitian Global theming via Stylix — applies Catppuccin Macchiato (base16) across
# all home-manager targets. Opacity, fonts, wallpaper, and polarity are set here.
# Stylix auto-enables on most targets; Zed is explicitly disabled (uses its own theme).
{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.packages = with pkgs; [
    # Icon fonts
    font-awesome
    material-design-icons

    # Nerd fonts for terminal/editor icons
    nerd-fonts.intone-mono
    nerd-fonts.symbols-only
  ];

  stylix = {
    enable = true;

    autoEnable = true;

    opacity = {
      applications = 0.96;
      desktop = 1.0;
      popups = 0.94;
      terminal = 0.92;
    };

    base16Scheme = ./theme/base16/catppuccin/macciato.yaml;

    fonts = {
      monospace = {
        name = "IntoneMono Nerd Font Mono";
        package = pkgs.nerd-fonts.intone-mono;
      };

      sansSerif = {
        name = "Ubuntu Sans";
        package = pkgs.ubuntu-sans;
      };

      serif = {
        name = "Ubuntu";
        package = pkgs.ubuntu-classic;
      };

      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };

      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 13;
      };
    };

    image = ./theme/wallpapers/rx7.png;

    polarity = "dark";

    targets = {
      firefox.profileNames = [ "default" ];
      librewolf.profileNames = [ "default" ];
      zed.enable = false;

      # Better Rofi styling
      rofi.enable = true;

      # GTK theming
      gtk.enable = true;

      # Foot terminal
      foot.enable = true;

      # Bat (cat replacement)
      bat.enable = true;

      # fzf
      fzf.enable = true;
    };
  };
}
