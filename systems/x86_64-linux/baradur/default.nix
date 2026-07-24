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
      options = "--delete-older-than 14d";
    };
  };

  home-manager.backupFileExtension = "hm-backup";

  networking.hostName = "baradur";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # MSI board Super I/O (NCT6687) — exposes motherboard fan headers + temps to lm_sensors/coolercontrol
    extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
    kernelModules = [ "nct6687" ];

    # teo ignores iowait counts; menu keeps cores in shallow C-states whenever iowait is pending,
    # and ghostty's io_uring event loops pin phantom iowait 24/7. Only takes effect once
    # Global C-state Control is re-enabled in BIOS (cpuidle driver is "none" without it).
    kernelParams = [ "cpuidle.governor=teo" ];

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
        configurationLimit = 10;
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
    dunst.enable = true;
    hyprland.enable = true;
    sddm.enable = true;
    nvidia.enable = true;
    erigon.sepolia.enable = false;
    geth.sepolia.enable = false;

    wireguard = {
      dns = [ "9.9.9.9" ];
      enable = true;
      interface = "wg0";
      ips = [
        "10.200.255.254/32"
        "fd3c:fd4c:b4e7:74d1:ffff:ffff:ffff:fffe/128"
      ];
      peers = [
        {
          publicKey = "raWuekoXvFFlrAQA0kFM9MG0dvRK3DXSXhHRDkQrJ10=";
          endpoint = "15.222.132.212:443";
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
      ghostty
      mdadm
      pciutils
      proton-pass
      qalculate-gtk
      shotman
      usbutils
      lm_sensors
      libsecret
      gimp
      cherry-studio
      nvitop
      zoom-us
      python3 # on PATH for Claude Code stop hooks that shell out to python3
    ];

    sessionVariables = {
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox"; # Set default browser
    };
  };

  services = {
    # Holds the Corsair Commander ST (AIO) in software lighting mode and drives the LEDs,
    # which stops CoolerControl's once-per-poll hardware-lighting blink (liquidctl#448:
    # unfixable in liquidctl; software-mode lighting is immune while OpenRGB runs).
    hardware.openrgb.enable = true;

    openssh.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    ollama = {
      enable = false;
      package = pkgs.ollama-cuda;
      loadModels = [
        "deepseek-r1:14b"
        "gemma3:12b"
        "gpt-oss:20b"
        "phi3:14b"
      ];
    };

    open-webui = {
      enable = false;
      host = "0.0.0.0";
      port = 1111;
      environment = {
        "WEBUI_AUTH" = "False";
      };
    };

    vsftpd = {
      enable = true;
      chrootlocalUser = true;
      localUsers = true;
      writeEnable = true;
    };
  };

  security.rtkit.enable = true;

  # Allow passwordless VPN toggle from waybar
  security.sudo.extraRules = [
    {
      users = [ "arrayofone" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start wg-quick-wg0.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop wg-quick-wg0.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/wg show wg0 latest-handshakes";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    thunar.enable = true;

    # Fan curve control for the Lian Li UNI hub + Corsair Commander Core (L-Connect/iCUE equivalent)
    coolercontrol.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  # Lian Li UNI FAN SL v1.2 hub: firmware ignores HID writes, so CoolerControl/liquidctl
  # can't drive it (liquidctl#858). This fork speaks the vendor control-transfer protocol
  # and applies /etc/uni-sync/uni-sync.json at boot. First run generates the file with
  # detected devices; set each channel to mode "Manual" + speed (percent), then restart.
  systemd.services.uni-sync = {
    description = "Apply Lian Li Uni fan hub speeds";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.${namespace}.uni-sync}/bin/uni-sync";
    };
  };

  hardware = {
    nvidia-container-toolkit.enable = true;

    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services.blueman.enable = true;

  virtualisation = {
    oci-containers.backend = "podman";

    containers.enable = true;
    docker.enable = true;
  };

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

  system.stateVersion = "24.05";

  i18n.defaultLocale = "en_CA.UTF-8";

  time.timeZone = "America/Vancouver";
}
