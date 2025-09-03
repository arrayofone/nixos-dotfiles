# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ namespace, pkgs, ... }:

{
  imports = [
    <nixos-hardware/raspberry-pi/4>
    ./hardware-configuration.nix
  ];

  # System identification
  networking.hostName = "k3s-node";
  system.stateVersion = "24.05";

  # Raspberry Pi 4 hardware configuration
  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
    enableRedistributableFirmware = true;
  };

  # Boot configuration optimized for k3s
  boot = {
    kernelParams = [
      "console=tty0"
      "cgroup_enable=cpuset"
      "cgroup_enable=memory"
      "cgroup_memory=1"
    ];
  };

  # Network configuration
  networking = {
    useNetworkd = true;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
  };

  # k3s Kubernetes cluster
  ${namespace}.programs.k3s = {
    enable = true;
    role = "server";

    # For single-node cluster, enable cluster-init
    clusterInit = true;

    # Customize networking if needed
    networking = {
      clusterCIDR = "10.42.0.0/16";
      serviceCIDR = "10.43.0.0/16";
      clusterDNS = "10.43.0.10";
      flannelBackend = "vxlan";
    };

    # Disable components not needed for edge
    disableComponents = [
      # "traefik"  # Uncomment to disable Traefik
    ];

    # Additional flags for Raspberry Pi optimization
    extraFlags = [
      "--kubelet-arg=max-pods=50"
      "--kubelet-arg=system-reserved=cpu=200m,memory=200Mi"
      "--kubelet-arg=kube-reserved=cpu=200m,memory=200Mi"
    ];

    # Deploy initial manifests
    manifests = {
      "namespace" = ''
        apiVersion: v1
        kind: Namespace
        metadata:
          name: apps
          labels:
            name: apps
      '';

      "example-deployment" = ''
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: nginx-example
          namespace: apps
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: nginx
          template:
            metadata:
              labels:
                app: nginx
            spec:
              containers:
              - name: nginx
                image: nginx:alpine
                ports:
                - containerPort: 80
                resources:
                  requests:
                    cpu: 50m
                    memory: 64Mi
                  limits:
                    cpu: 100m
                    memory: 128Mi
        ---
        apiVersion: v1
        kind: Service
        metadata:
          name: nginx-service
          namespace: apps
        spec:
          type: NodePort
          selector:
            app: nginx
          ports:
          - port: 80
            targetPort: 80
            nodePort: 30080
      '';
    };

    openFirewall = true;
  };

  # Essential services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    timesyncd.enable = true;

    resolved = {
      enable = true;
      dnssec = "false";
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };

    # Log rotation to prevent SD card wear
    logrotate = {
      enable = true;
      settings = {
        header = {
          dateext = true;
          compress = true;
          rotate = 5;
          daily = true;
        };
      };
    };

    journald.extraConfig = ''
      SystemMaxUse=200M
      SystemMaxFiles=10
      SystemMaxFileSize=20M
    '';
  };

  # User management
  users = {
    mutableUsers = false;
    users.admin = {
      isNormalUser = true;
      description = "System administrator";
      extraGroups = [
        "wheel"
        "systemd-journal"
      ];
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        # Add your SSH public keys here
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your-key-here"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # System packages
  environment.systemPackages = with pkgs; [
    # Raspberry Pi specific
    libraspberrypi
    raspberrypi-eeprom

    # k3s management tools (kubectl and helm are added by the module)
    k9s
    stern
    kubectx

    # System utilities

  ];

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
      # Optimize for Raspberry Pi
      max-jobs = 2;
      cores = 4;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  # Create k3s token file
  systemd.tmpfiles.rules = [
    "d /etc/secrets 0700 root root -"
    # For multi-node cluster, create token file:
    # "f /etc/secrets/k3s-token 0600 root root -"
  ];

  # Locale and timezone
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  # Power management for Raspberry Pi
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };
}
