{
  lib,
  pkgs,
  ...
}:
{
  fonts = {
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
