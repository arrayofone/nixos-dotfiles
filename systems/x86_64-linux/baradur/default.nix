{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };

    gc = {
      automatic = true;
      dates = [ "05:00" ];
    };
  };

  networking.hostName = "baradur";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  snowfallorg.users.arrayofone = {
    create = true;
    admin = true;

    home = {
      enable = true;
      config = { };
    };
  };

  users = {
    groups.arrayofone = { };

    users.arrayofone = {
      isNormalUser = true;
      group = "arrayofone";
      initialPassword = "letmein";
      description = "primordial devboi";
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "docker"
        "podman"
        "wheel"
        "libvirtd"
        "audio"
        "video"
        "vsftpd"
      ];
    };
  };

  fellowship = {
    gui.desktop = {
      dunst.enable = true;
      hyprland.enable = true;
      sddm = {
        enable = true;
      };
    };
    hardware.nvidia.enable = true;
    programs.ethereum.erigon.sepolia = {
      enable = false;
    };
    programs.ethereum.geth.sepolia = {
      enable = false;
    };

    networking.wireguard.server = {
      enable = true;
      interface = "wg0";
      externalInterface = "enp42s0";
      port = "$(cat ${config.sops.secrets."vpn/wg/port".path})";
      ips = [ "10.20.255.253/16" ];
      privateKeyFile = config.sops.secrets."vpn/wg/privateKey".path;
      routes = [
        {
          destination = "$(cat ${config.sops.secrets."vpn/wg/endpoint-ip".path})";
          via = "10.10.10.1";
          dev = "enp42s0";
        }
      ];
      peers = [
        {
          publicKey = "4N2292pRHaViKm4TCSuDHa8x48ARn8tNZv1dSHWRuhA=";
          endpoint = "wg.arrayof.one:443";
        }
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      alacritty
      dconf
      foot
      ghostty
      kitty
      libqalculate
      mdadm
      pciutils
      proton-pass
      qalculate-gtk
      shotman
      usbutils
      nixfmt
      libsecret
      gimp
      zip
      unzip
    ];

    sessionVariables = {
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox"; # Set default browser
    };
  };

  hardware = { };

  services = {
    pulseaudio = {
      enable = false;
      extraConfig = "unload-module module-suspend-on-idle";
    };

    openssh.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire-pulse = {
        "99-disable-suspend" = {
          "pulse.cmd" = [
            {
              cmd = "unload-module";
              args = "module-suspend-on-idle";
              flags = [ "nofail" ];
            }
          ];
        };
      };
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    ollama = {
      enable = false;
      acceleration = "cuda";
      loadModels = [
        "deepseek-r1"
        "incept5/llama3.1-claude"
      ];
    };

    open-webui.enable = false;
    vsftpd = {
      # allowWriteableChroot
      # anonymousMkdirEnable
      # anonymousUmask
      # anonymousUploadEnable
      # anonymousUser
      # anonymousUserHome
      # anonymousUserNoPassword
      chrootlocalUser = true;
      enable = true;
      # enableVirtualUsers
      # extraConfig
      # forceLocalDataSSL
      # forceLocalLoginsSSL
      # localRoot
      localUsers = true;
      # portPromiscuous
      # rsaCertFile
      # rsaKeyFile
      # ssl_sslv2
      # ssl_sslv3
      # ssl_tlsv1
      # userDbPath
      # userlist
      # userlistDeny
      # userlistEnable
      # userlistFile
      # virtualUseLocalPrivs
      writeEnable = true;
    };
  };

  security.rtkit.enable = true;

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    thunar.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  virtualisation = {
    oci-containers.backend = "podman";

    containers = {
      enable = true;
    };

    docker = {
      enable = true;
    };

    podman = {
      enable = false;
      dockerCompat = false;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = false;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8082
      5432
      5433
      5434
      3000
      21
      20
    ];
    checkReversePath = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  system.stateVersion = "24.05"; # Did you read the comment?

  i18n.defaultLocale = "en_CA.UTF-8";

  time.timeZone = "America/Vancouver";
}
