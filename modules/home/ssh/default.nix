# @gitian:security SSH config with split GitHub identities.
# `gh-personal` key maps to `github.com` directly.
# `gh-work` key maps to `gitwork` host alias (resolves to `github.com`).
# Work repos use `gitwork:org/repo` as remote URL to trigger the correct key.
{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      personal = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/gh-personal";
      };
      work = {
        host = "gitwork";
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/gh-work";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
