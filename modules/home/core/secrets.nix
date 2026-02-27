# @gitian:secret Home-manager secrets via sops-nix.
# Decrypts `secrets/<username>.yaml` at activation time using the user's age key.
# Secrets are exposed as files under `config.sops.secrets.<name>.path`.
# See [[secrets]] for the full encryption flow.
{
  config,
  inputs,
  lib,
  ...
}:
let
  secrets = lib.snowfall.fs.get-file "secrets";
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    # age.keyFile = "/home/${config.snowfallorg.user.name}/.age-key.txt"; # must have no password!
    # It's also possible to use a ssh key, but only when it has no password:
    age.sshKeyPaths = [ "/home/${config.snowfallorg.user.name}/.ssh/sops-nix" ];
    defaultSopsFile = "${secrets}/${config.snowfallorg.user.name}.yaml";
    # secrets.test = {
    #   # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

    #   # %r gets replaced with a runtime directory, use %% to specify a '%'
    #   # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
    #   # DARWIN_USER_TEMP_DIR) on darwin.
    #   path = "%r/test.txt";
    # };
    #
    secrets = {
      "git/name" = { };
      "git/email" = { };
      "git/gh/ssh-private" = { };
      "git/gh/ssh-public" = { };
      "ai/anthropic/api-key" = { };
      "ai/gemini/api-key" = { };
    };
  };

  # export GEMINI_API_KEY="$(cat ${config.sops.secrets."ai/gemini/api-key".path})"
  programs.zsh.initContent = "";

  systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
}
