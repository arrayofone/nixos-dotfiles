{ pkgs, ... }:
{
  boot.kernelPackages =
    (import (builtins.fetchTarball "https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz"))
    .legacyPackages.aarch64-linux.linuxPackages_rpi5;

  networking = { };

  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      dates = "03:15";
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  i18n.defaultLocale = "en_CA.UTF-8";

  time.timeZone = "America/Vancouver";

  system.stateVersion = "24.05";
}
