{ config, ... }:
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
      export ANTHROPIC_API_KEY=$(cat ${config.sops.secrets."ai/anthropic/api-key".path})
    '';
  };
}
