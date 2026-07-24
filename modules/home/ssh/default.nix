# @gitian:security SSH config with split GitHub identities.
# `gh-personal` key maps to `github.com` directly.
# `gh-work` key maps to `gitwork` host alias (resolves to `github.com`).
# Work repos use `gitwork:org/repo` as remote URL to trigger the correct key.
{
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.ssh;
in
{
  options.${namespace}.ssh = {
    enable = lib.mkEnableOption "ssh" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentitiesOnly = true;
          IdentityFile = "~/.ssh/gh-personal";
        };
        gitwork = {
          HostName = "github.com";
          User = "git";
          IdentitiesOnly = true;
          IdentityFile = "~/.ssh/gh-work";
        };
        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };
      };
    };
  };
}
