{
  config,
  inputs,
  lib,
  namespace,
  ...
}:
{
  imports = [ inputs.sops-nix.darwinModules.sops ];

  sops = {
    defaultSopsFile = "${lib.snowfall.fs.get-file "secrets"}/${config.${namespace}.system.name}.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      "vpn/wg/endpoint" = { };
      "vpn/wg/endpoint-ip" = { };
      "vpn/wg/endpoint-ip-port" = { };
      "vpn/wg/port" = { };
      "vpn/wg/privateKey" = { };
    };
  };
}
