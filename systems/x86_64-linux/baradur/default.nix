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
      dconf
      ghostty
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
      zoom-us
    ];

    sessionVariables = {
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox"; # Set default browser
    };
  };

  services = {
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
    };

    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = [
        "deepseek-r1:14b"
        "gemma3:12b"
        "gpt-oss:20b"
        "phi3:14b"
      ];
    };

    open-webui = {
      enable = true;
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
      ];
    }
  ];

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
  };

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
