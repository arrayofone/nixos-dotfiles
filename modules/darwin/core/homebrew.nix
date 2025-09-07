{ config, ... }:
{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      cleanup = "uninstall";
      extraFlags = [ ];
      upgrade = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
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
      "brave-browser"
      "chromium"
      "cursor"
      "dbeaver-community"
      "discord"
      "element"
      "firefox"
      "ghostty"
      "gimp"
      "google-chrome"
      "hiddenbar"
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
      "zoom"
    ];
    masApps = {
      "amphetamine" = 937984704;
    };
  };
}
