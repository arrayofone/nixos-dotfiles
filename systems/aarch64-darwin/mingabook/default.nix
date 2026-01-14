{ ... }:
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

  homebrew = {
    taps = [ ];
    brews = [
      "bun@1.2.7"
      "gettext"
      "ghostscript"
      "git-lfs"
      "protoc-gen-grpc-web"
      "tmux"
    ];
    casks = [
      "arc"
      "brave-browser"
      "chromium"
      "cursor"
      "datagrip"
      "dbeaver-community"
      "discord"
      "firefox"
      "ghostty"
      "gimp"
      "goland"
      "google-chrome"
      "hiddenbar"
      "insomnia"
      "intellij-idea"
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
      "telegram"
      "visual-studio-code"
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
