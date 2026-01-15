{ ... }:
{
  fellowship.home.dev.enable = false;

  programs.zsh.envExtra = ''
    neofetch
  '';

  home = {
    # packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
