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

    primaryUser = "db";
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
      # "sops"
      "tmux"
    ];
    casks = [
      "arc"
      "bruno"
      "brave-browser"
      "chromium"
      "cursor"
      "datagrip"
      "dbeaver-community"
      "discord"
      "element"
      "firefox"
      "gimp"
      "goland"
      "google-chrome"
      "hiddenbar"
      "insomnia"
      "intellij-idea"
      "istat-menus"
      "messenger"
      "obsidian"
      "orbstack"
      "postman"
      "proton-mail"
      "slack"
      "spotify"
      "telegram"
      "tuple"
      "visual-studio-code"
      "whatsapp"
      "zen"
      "zoom"
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
