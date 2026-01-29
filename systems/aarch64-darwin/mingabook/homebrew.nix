{ config, ... }:
{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };
    onActivation = {
      cleanup = "zap";
      extraFlags = [ ];
      upgrade = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
