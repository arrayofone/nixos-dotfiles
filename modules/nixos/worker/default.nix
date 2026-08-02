{ lib, config, pkgs, namespace, ... }:
let
  cfg = config.${namespace}.worker;
in
{
  imports = [ ./root.nix ];

  options.${namespace}.worker = {
    enable = lib.mkEnableOption "diskless k3s worker profile";

    board = lib.mkOption {
      type = lib.types.enum [ "pi4" "pi5" ];
      default = "pi4";
      description = "Selects the initrd NIC module (pi4 = bcmgenet, pi5 = macb) and DTB.";
    };

    bootServer = lib.mkOption {
      type = lib.types.str;
      example = "10.0.30.2";
      description = "baradur's address on the worker VLAN (used by ram/nfs root modes).";
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Operator SSH keys for the kubeconfig fetch / administration.";
    };

    root = {
      mode = lib.mkOption {
        type = lib.types.enum [ "ram" "nfs" "local" ];
        default = "ram";
      };
      target = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "ram: unused (root is in the initrd); nfs: 'host:/export'; local: block device path.";
      };
      extraConfig = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
    };

    k3s = {
      role = lib.mkOption {
        type = lib.types.enum [ "server" "agent" ];
        default = "server";
      };
      target = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "agent: server URL e.g. https://10.0.30.5:6443.";
      };
      tokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to the k3s join token (from sops).";
      };
      stateDevice = lib.mkOption {
        type = lib.types.str;
        example = "/dev/disk/by-label/K3S_STATE";
        description = "Local block device for k3s state + node identity (mounted at /state).";
      };
      extraConfig = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.monitoring.agent = {
      enable = lib.mkDefault true;
      lokiUrl = lib.mkDefault "http://${cfg.bootServer}:3100";
    };

    assertions = [
      {
        assertion = cfg.k3s.role == "server" -> cfg.k3s.target == null;
        message = "fellowship.worker: k3s.target must be null when role = server.";
      }
      {
        assertion = cfg.k3s.role == "agent" -> (cfg.k3s.target != null && cfg.k3s.tokenFile != null);
        message = "fellowship.worker: agents need k3s.target and k3s.tokenFile.";
      }
    ];

    # Mount the state device ONCE, then bind real subdirs of it. The device holds k3s state,
    # the ssh host key (node identity for sops), and the sops age key.
    fileSystems."/state" = {
      device = cfg.k3s.stateDevice;
      fsType = "ext4";
      neededForBoot = true;
    };
    fileSystems."/etc/ssh" = {
      device = "/state/ssh";
      options = [ "bind" ];
      neededForBoot = true;
    };
    fileSystems."/var/lib/sops-nix" = {
      device = "/state/sops-nix";
      options = [ "bind" ];
      neededForBoot = true;
    };
    fileSystems."/var/lib/rancher/k3s" = {
      device = "/state/rancher";
      options = [ "bind" ];
    };

    # k3s via mkMerge so extraConfig MERGES (not //-clobbers) and types are checked.
    services.k3s = lib.mkMerge [
      {
        enable = true;
        role = cfg.k3s.role;
        tokenFile = cfg.k3s.tokenFile;
      }
      (lib.mkIf (cfg.k3s.role == "agent") {
        serverAddr = cfg.k3s.target;
      })
      (lib.mkIf (cfg.k3s.role == "server") {
        extraFlags = [
          "--disable=traefik"
          "--write-kubeconfig-mode=0600" # admin creds not world-readable
          "--cluster-init" # embedded etcd so `etcd-snapshot` works
        ];
        # In-cluster NFS provisioner client — csi-driver-nfs via k3s auto-deploy manifest, plus
        # the StorageClass PVCs bind against. Server-only: agents don't run the k3s
        # apiserver/controller that consumes manifests/.
        manifests.nfs-csi.content = [
          {
            apiVersion = "helm.cattle.io/v1";
            kind = "HelmChart";
            metadata = {
              name = "csi-driver-nfs";
              namespace = "kube-system";
            };
            spec = {
              chart = "csi-driver-nfs";
              repo = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts";
              targetNamespace = "kube-system";
            };
          }
          {
            apiVersion = "storage.k8s.io/v1";
            kind = "StorageClass";
            metadata.name = "nfs";
            provisioner = "nfs.csi.k8s.io";
            parameters = {
              server = cfg.bootServer;
              share = "/k8s-pvcs"; # ON-HARDWARE-VALIDATE: NFSv4 pseudo-root path vs absolute export path
            };
            reclaimPolicy = "Delete";
            mountOptions = [ "nfsvers=4.1" ];
          }
        ];
      })
      cfg.k3s.extraConfig
    ];
    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.k3s.role == "server") [ 6443 ];

    # etcd snapshots must live OFF the K3S_STATE device (its loss is what they insure against),
    # hence NFS to baradur. Server-only: agents run no etcd to snapshot.
    systemd.services.k3s-etcd-snapshot = lib.mkIf (cfg.k3s.role == "server") {
      description = "k3s embedded etcd snapshot";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.k3s}/bin/k3s etcd-snapshot save --snapshot-dir /mnt/etcd-snapshots";
      };
    };
    systemd.timers.k3s-etcd-snapshot = lib.mkIf (cfg.k3s.role == "server") {
      description = "Daily k3s embedded etcd snapshot";
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "03:30";
    };
    # soft+automount so an unreachable baradur can't hang boots.
    fileSystems."/mnt/etcd-snapshots" = lib.mkIf (cfg.k3s.role == "server") {
      device = "${cfg.bootServer}:/k8s-pvcs/etcd-snapshots"; # ON-HARDWARE-VALIDATE: same pseudo-root caveat as the StorageClass share.
      fsType = "nfs";
      options = [ "nfsvers=4.1" "soft" "x-systemd.automount" "x-systemd.idle-timeout=300" "noauto" ];
    };

    environment.systemPackages = [
      pkgs.k3s
      pkgs.nfs-utils
    ];

    services.openssh.enable = true;
    # Operator SSH for the kubeconfig fetch — as arrayofone + passwordless sudo, no root login.
    users.users.arrayofone.openssh.authorizedKeys.keys = cfg.authorizedKeys;
    security.sudo.wheelNeedsPassword = lib.mkDefault false;

    snowfallorg.users.arrayofone.home.enable = false;

    # mkDefault so host files / other hosts never conflict.
    system.stateVersion = lib.mkDefault "24.05";
    i18n.defaultLocale = lib.mkDefault "en_CA.UTF-8";
    time.timeZone = lib.mkDefault "America/Vancouver";
  };
}
