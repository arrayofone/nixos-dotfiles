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
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Ubuntu Nerd Font" ];
        sansSerif = [ "UbuntuSans Nerd Font" ];
        monospace = [ "IntoneMono Nerd Font Mono" ];
      };

      hinting = {
        autohint = true;
        enable = true;
      };
    };

    packages =
      with pkgs;
      [
        dina-font
        fontconfig

        noto-fonts
        noto-fonts-emoji

        proggyfonts
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}
