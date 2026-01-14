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
    initContent = lib.mkAfter (
      lib.optionalString (builtins.hasAttr "ai/anthropic/api-key" config.sops.secrets) ''
        if [ -f "${config.sops.secrets."ai/anthropic/api-key".path}" ]; then
          export ANTHROPIC_API_KEY=$(cat "${config.sops.secrets."ai/anthropic/api-key".path}")
        fi
      ''
    );
  };
}
