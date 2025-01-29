{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
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
    defaultSopsFile = "${secrets}/${namespace}.yaml";
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
    };
  };

  systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
}
