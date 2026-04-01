{
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

      hinting = "full";

      # subpixelRendering = "rgb";
    };
  };
}
