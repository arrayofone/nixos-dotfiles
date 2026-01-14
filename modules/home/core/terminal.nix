{
  pkgs,
  ...
}:
{
  programs = {
    alacritty.enable = true;
    foot.enable = false;
    ghostty.enable = false;
    kitty.enable = true;
  };

  # home.packages = [ pkgs.foot ];

  programs.foot = {
    package = pkgs.foot;
  };
}
