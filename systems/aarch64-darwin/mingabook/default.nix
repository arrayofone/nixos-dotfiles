# @gitian:host mingabook system config — primary development machine (aarch64-darwin).
# Installs Rosetta 2, configures Homebrew casks, enables Touch ID sudo,
# and sets up weekly Nix garbage collection.
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

  home-manager.backupFileExtension = "hm-backup";

  environment.systemPackages = with pkgs; [
    mkcert
    nodejs_20
    pnpm
    python310
    raycast
    fellowship.scroll-reverser
  ];

  # @gitian:todo Enable AeroSpace tiling window manager for macOS
  services.aerospace = {
    enable = false;
  };

  homebrew = {
    taps = [ ];
    brews = [
      "git-lfs"
      "nvm"
      "tmux"
    ];
    casks = [
      "arc"
      "chromium"
      "claude"
      "dbeaver-community"
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
