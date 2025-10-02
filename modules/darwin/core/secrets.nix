{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.sops-nix.darwinModules.sops ];

  sops = {
    defaultSopsFile = "${lib.snowfall.fs.get-file "secrets"}/${config.system.name}.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = { };
  };
}
