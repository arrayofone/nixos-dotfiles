{
  config,
  namespace,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
      trusted-users = [ "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = [ "05:00" ];
    };
  };

  home-manager.backupFileExtension = "hm-backup";

  networking.hostName = "baradur";

  boot = {
    kernelPackages = pkgs.linuxPackages_6_6;

    loader = {
      systemd-boot.enable = false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
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
      hashedPasswordFile = config.sops.secrets."system/users/arrayofone/password".path;
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
      dns = [ "1.1.1.1" ];
      enable = true;
      interface = "wg0";
      ips = [
        "10.200.255.254/32"
        "fd3c:fd4c:b4e7:74d1:ffff:ffff:ffff:fffe/128"
      ];
      peers = [
        {
          publicKey = "4N2292pRHaViKm4TCSuDHa8x48ARn8tNZv1dSHWRuhA=";
          endpoint = "wg.arrayof.one:443";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
      privateKeyFile = config.sops.secrets."vpn/wg/privateKey".path;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      dconf
      libqalculate
      mdadm
      pciutils
      proton-pass
      qalculate-gtk
      shotman
      usbutils
      libsecret
      gimp
      cherry-studio
      nvitop
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
      enable = true;

      loadModels = [
        # general models
        "deepseek-r1:14b"
        "gemma3:12b"
        "gpt-oss:20b"
        "phi3:14b"
      ];
      # environmentVariables = ;
      # group = ;
      # home = ;
      # host = ;
      # models = ;
      # openFirewall = ;
      package = pkgs.ollama-cuda;
      # port = ;
      # rocmOverrideGfx = ;
      # user = ;
    };

    open-webui = {
      enable = true;
      environment = {
        "WEBUI_AUTH" = "False";
      };
      # environmentFile = ;
      host = "0.0.0.0";
      # openFirewall = ;
      # package = ;
      port = 1111;
      # stateDir = ;
    };

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
      11434
      8082
      5432
      5433
      5434
      3000
      1111
      443
      21
      20
    ];
    checkReversePath = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #

  system.stateVersion = "24.05"; # Did you read the comment?

  i18n.defaultLocale = "en_CA.UTF-8";

  time.timeZone = "America/Vancouver";
}
