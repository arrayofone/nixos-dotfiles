# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  # imports = [
  #   ./hardware-configuration.nix
  #   # pkgs.fetchTarball awsVpnClient
  # ];

  boot.kernelPackages =
    (import (builtins.fetchTarball "https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz"))
    .legacyPackages.aarch64-linux.linuxPackages_rpi5;

  # boot = {
  #   loader = {
  #     systemd-boot.enable = true;
  #     efi.canTouchEfiVariables = true;
  #   };
  # };

  # environment = {
  #   systemPackages = [
  #     # pkgs.docker
  #     # pkgs.docker-compose
  #     # pkgs.virt-manager
  #     # pkgs.virt-viewer
  #     # pkgs.usbutils
  #     # pkgs.pciutils
  #     # pkgs.wireguard-tools
  #     # pkgs.dconf
  #     # pkgs.xclip
  #     # pkgs.wget
  #     # pkgs.bash
  #     # pkgs.git
  #     # pkgs.fontconfig
  #     # pkgs.vim-full
  #     # pkgs.nil
  #     # pkgs.openssl
  #     # pkgs.virt-viewer
  #     # pkgs.proton-pass
  #     # pkgs.protonvpn-cli
  #     # pkgs.kitty
  #     # pkgs.alacritty
  #     # pkgs.foot
  #     # pkgs.zellij
  #     # pkgs.gnupg
  #     # pkgs.pinentry-curses
  #     # pkgs.lsof
  #     # pkgs.zsh
  #     # pkgs.lf
  #     # pkgs.ripgrep
  #     # pkgs.htop
  #     # pkgs.neofetch
  #     # pkgs.jq
  #     # pkgs.bat
  #     # pkgs.tmux
  #     # pkgs.postgresql # for cli tooling
  #     # pkgs.gcc
  #     # pkgs.mdadm
  #     # pkgs.podman
  #     # pkgs.podman-compose
  #     # pkgs.podman-tui
  #   ];

  #   # sessionVariables = {
  #   #     DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox"; # Set default browser
  #   # };
  # };

  # hardware = {
  #   pulseaudio.enable = false;
  #   pulseaudio.extraConfig = "unload-module module-suspend-on-idle";
  # };

  networking = {

  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      dates = "03:15";
    };
  };

  # services = {
  #   printing.enable = true;
  #   pipewire = {
  #     enable = true;
  #     alsa.enable = true;
  #     alsa.support32Bit = true;
  #     pulse.enable = true;

  #     extraConfig.pipewire-pulse = {
  #       "99-disable-suspend" = {
  #         "pulse.cmd" = [
  #           { cmd = "unload-module"; args = "module-suspend-on-idle"; flags = [ "nofail" ]; }
  #         ];
  #       };
  #     };
  #     # If you want to use JACK applications, uncomment this
  #     #jack.enable = true;

  #     # use the example session manager (no others are packaged yet so this is enabled by default,
  #     # no need to redefine it in your config for now)
  #     #media-session.enable = true;
  #   };
  # };

  # security.rtkit.enable = true;

  # programs = {
  #   zsh.enable = true;
  #   dconf.enable = true;

  #   # Some programs need SUID wrappers, can be configured further or are
  #   # started in user sessions.
  #   # programs.mtr.enable = true;
  #   # programs.gnupg.agent = {
  #   #   enable = true;
  #   #   enableSSHSupport = true;
  #   # };
  # };

  # virtualisation = {
  #   oci-containers.backend = "podman";

  #   containers = {
  #     enable = true;
  #   };

  #   docker = {
  #     enable = true;
  #   };

  #   libvirtd = {
  #     enable = true;
  #     # Used for UEFI boot of Home Assistant OS guest image

  #     qemu = {
  #       ovmf = {
  #         enable = true;
  #       };
  #     };
  #   };

  #   # oci-containers = {
  #   #   backend = "docker";
  #   #   containers.homeassistant = {
  #   #     volumes = [ "home-assistant:/config" ];
  #   #     environment.TZ = "America/Vancouver";
  #   #     image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
  #   #     extraOptions = [
  #   #       "--network=host"
  #   #       # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
  #   #     ];
  #   #   };
  #   #   containers.homeassistantOmniBridge = {
  #   #     # volumes = [ "home-assistant:/config" ];
  #   #     environment.TZ = "America/Vancouver";
  #   #     image = "github.com/excaliburpartners/hassio-addons/tree/master/omnilink-bridge"; # Warning: if the tag does not change, the image will not be updated
  #   #     extraOptions = [
  #   #       "--network=host"
  #   #       # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
  #   #     ];
  #   #   }
  #   # };

  #   podman = {
  #     enable = false;

  #     # Create a `docker` alias for podman, to use it as a drop-in replacement
  #     dockerCompat = false;

  #     # Required for containers under podman-compose to be able to talk to each other.
  #     defaultNetwork.settings.dns_enabled = false;
  #     #dockerSocket.enable = true;
  #     # extraPackages = [ pkgs.zfs ];
  #   };
  # };

  # environment.extraInit = ''
  #   if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
  #     export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  #   fi
  # '';

  # Enable automatic login for the user.
  # services.displayManager.execCmd

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  i18n.defaultLocale = "en_CA.UTF-8";

  # hostFonts.enable = true;

  time.timeZone = "America/Vancouver";

  system.stateVersion = "24.05";
}
