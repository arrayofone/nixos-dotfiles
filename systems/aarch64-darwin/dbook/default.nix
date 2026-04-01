{ namespace, ... }:
{
  imports = [
    ./networking.nix
    ./users.nix
  ];

  ${namespace} = {
    system.name = "dbook";
  };

  system = {
    activationScripts.extraActivation.text = ''
      test -d /usr/libexec/rosetta || softwareupdate --install-rosetta --agree-to-license
    '';

    primaryUser = "db";
    stateVersion = 6;
  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
