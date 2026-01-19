{ config, lib, ... }:
{
  home = {
    sessionVariables = {
      EDITOR = "zeditor";
    };
  };

  # read secrets into env at runtime to prevent embedding
  # secrets into the build as sessionVariables does
  programs.zsh = {
    initContent = ''
      export NX_TUI=false
      export NVM_DIR="$HOME/.nvm"
      [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
      [ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"
    ''
    + lib.optionalString (builtins.hasAttr "ai/anthropic/api-key" config.sops.secrets) ''
      if [ -f "${config.sops.secrets."ai/anthropic/api-key".path}" ]; then
        export ANTHROPIC_API_KEY=$(cat "${config.sops.secrets."ai/anthropic/api-key".path}")
      fi
    '';
  };
}
