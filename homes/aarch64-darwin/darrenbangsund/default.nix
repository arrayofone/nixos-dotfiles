{ ... }:
{
  # fellowship.home = {
  #   dev.enable = false;
  #   programs.zeditor = {
  #     nodePath = lib.getExe pkgs.nodejs_20;
  #     npmPath = lib.getExe' pkgs.nodejs_20 "npm";
  #   };
  # };

  programs.zsh.envExtra = ''
      export NX_TUI=false
    	export NVM_DIR="$HOME/.nvm"
    	[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
    	[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"
      fastfetch
  '';

  home = {
    # packages = with pkgs; [ ];
    stateVersion = "24.05";
  };
}
