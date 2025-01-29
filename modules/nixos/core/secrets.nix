{
  inputs,
  lib,
  namespace,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${lib.snowfall.fs.get-file "secrets"}/${namespace}.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      "git/name" = { };
      "git/email" = { };
      "git/gh/ssh-private" = { };
      "git/gh/ssh-public" = { };
      "ai/anthropic/api-key" = { };
    };
  };
}
