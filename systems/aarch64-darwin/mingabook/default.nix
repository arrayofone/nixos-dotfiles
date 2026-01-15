{ lib, pkgs, ... }:
{
  imports = [
    ./homebrew.nix
    ./networking.nix
    ./programs.nix
    ./users.nix
  ];

  system = {
    activationScripts.extraActivation.text = ''
      test -d /usr/libexec/rosetta || softwareupdate --install-rosetta --agree-to-license
    '';

    primaryUser = "darrenbangsund";
    stateVersion = 6;
  };

  environment.systemPackages = with pkgs; [
    mkcert
    nodejs_21
    pnpm
    python310
  ];

  homebrew = {
    taps = [ ];
    brews = [
      "git-lfs"
      "tmux"
    ];
    casks = [
      "arc"
      "chromium"
      "discord"
      "firefox"
      "ghostty"
      "google-chrome"
      "istat-menus"
      "linear-linear"
      "messenger"
      "obsidian"
      "orbstack"
      "postman"
      "proton-mail"
      "proton-pass"
      "slack"
      "spotify"
      "whatsapp"
      "zen"
    ];
    masApps = {
      "amphetamine" = 937984704;
    };
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
