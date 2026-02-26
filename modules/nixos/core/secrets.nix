{
  config,
  inputs,
  lib,
  namespace,
  ...
}:
let
  wgEnabled = config.${namespace}.networking.wireguard.server.enable;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${lib.snowfall.fs.get-file "secrets"}/${config.system.name}.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets =
      {
        "system/users/arrayofone/password" = {
          neededForUsers = true;
        };
      }
      // lib.optionalAttrs wgEnabled {
        "vpn/wg/endpoint" = { };
        "vpn/wg/port" = { };
        "vpn/wg/privateKey" = { };
      };
  };
}
