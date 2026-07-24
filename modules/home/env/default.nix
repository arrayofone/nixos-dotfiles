# @gitian:security Runtime secret injection — reads SOPS-decrypted files into
# environment variables at shell init, avoiding Nix store embedding.
# `sessionVariables` would bake secrets into the store; `initContent` reads them at runtime.
{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.env;
in
{
  options.${namespace}.env = {
    enable = lib.mkEnableOption "env" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "zeditor";
      };
    };

    # read secrets into env at runtime to prevent embedding
    # secrets into the build as sessionVariables does
    programs.zsh = {
      initContent = lib.concatStrings [
        (lib.optionalString (builtins.hasAttr "ai/anthropic/api-key" config.sops.secrets) ''
          if [ -f "${config.sops.secrets."ai/anthropic/api-key".path}" ]; then
            export ANTHROPIC_API_KEY=$(cat "${config.sops.secrets."ai/anthropic/api-key".path}")
          fi
        '')
        (lib.optionalString (builtins.hasAttr "localstack/auth-token" config.sops.secrets) ''
          if [ -f "${config.sops.secrets."localstack/auth-token".path}" ]; then
            export LOCALSTACK_AUTH_TOKEN=$(cat "${config.sops.secrets."localstack/auth-token".path}")
          fi
        '')
      ];
    };
  };
}
