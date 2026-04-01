# @gitian:security Runtime secret injection — reads SOPS-decrypted files into
# environment variables at shell init, avoiding Nix store embedding.
# `sessionVariables` would bake secrets into the store; `initContent` reads them at runtime.
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
    initContent = lib.optionalString (builtins.hasAttr "ai/anthropic/api-key" config.sops.secrets) ''
      if [ -f "${config.sops.secrets."ai/anthropic/api-key".path}" ]; then
        export ANTHROPIC_API_KEY=$(cat "${config.sops.secrets."ai/anthropic/api-key".path}")
      fi
    '';
  };
}
