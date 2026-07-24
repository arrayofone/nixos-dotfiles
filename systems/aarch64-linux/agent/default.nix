{ pkgs, ... }:
{
  # Mainline kernel for now. The previous unpinned fetchTarball of a
  # third-party nix-rpi5 repo broke pure evaluation; the vendor Pi 5
  # kernel/firmware returns via nixos-raspberrypi in the pi-netboot plan's
  # Phase 5 (see flake.nix note on the current upstream incompatibility).

  # SD boot via the firmware's extlinux path, as on the stock aarch64 sd-image
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Standard Pi sd-image layout; superseded by the fellowship.worker root
  # modes when the netboot plan's Phase 5 lands.
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  networking = { };

  fellowship.monitoring.agent.enable = true;

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
