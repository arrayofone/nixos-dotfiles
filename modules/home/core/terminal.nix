{
  pkgs,
  ...
}:
{
  programs = {
    alacritty.enable = true;
    foot.enable = true;
    ghostty.enable = true;
    kitty.enable = true;
  };

  # home.packages = [ pkgs.foot ];

  programs.foot = {
    package = pkgs.foot;
  };
}
