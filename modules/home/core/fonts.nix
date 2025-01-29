{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    fontconfig
    nerd-fonts.intone-mono
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    nerd-fonts.liberation
  ];

  # fonts = {
  #   fontconfig = {
  #     enable = true;
  #     defaultFonts = {
  #       sansSerif = [ pkgs.nerd-fonts.ubuntu.name ];
  #       monospace = [ pkgs.nerd-fonts.ubuntu-mono.name ];
  #     };
  #   };
  # };
}
