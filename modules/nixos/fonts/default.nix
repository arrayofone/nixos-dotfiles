{
  lib,
  pkgs,
  ...
}:
{
  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        emoji = [ pkgs.noto-fonts-color-emoji.name ];
        serif = [ pkgs.nerd-fonts.ubuntu.name ];
        sansSerif = [ pkgs.nerd-fonts.ubuntu-sans.name ];
        monospace = [ pkgs.nerd-fonts.intone-mono.name ];
      };

      hinting = {
        autohint = true;
        enable = true;
      };

      antialias = true;
    };

    packages =
      with pkgs;
      [
        dina-font
        fontconfig

        noto-fonts
        noto-fonts-color-emoji

        proggyfonts
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}
