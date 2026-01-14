{ config, ... }:
{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      cleanup = "zap";
      extraFlags = [ ];
      upgrade = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
