{ ... }:
{
  fellowship.home.dev.enable = true;

  programs.zsh.envExtra = ''
    neofetch
  '';

  home = {
    # packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
