{ lib, config, namespace, ... }:
let
  cfg = config.${namespace}.netboot;
  vlanIface = "${cfg.parentInterface}.${toString cfg.vlan}";
  hostIp = lib.head (lib.splitString "/" cfg.serverAddress);
  prefix = lib.toInt (lib.last (lib.splitString "/" cfg.serverAddress));
  octets = lib.splitString "." hostIp;
  netAddr = "${lib.concatStringsSep "." (lib.take 3 octets)}.0"; # /24 only — asserted below
in
{
  options.${namespace}.netboot = {
    enable = lib.mkEnableOption "diskless Pi netboot server (proxy-DHCP + TFTP + NFS)";
    parentInterface = lib.mkOption {
      type = lib.types.str;
      example = "enp42s0";
      description = "Physical NIC on baradur carrying the worker VLAN tag.";
    };
    vlan = lib.mkOption {
      type = lib.types.int;
      example = 30;
      description = "UniFi-managed worker VLAN id.";
    };
    serverAddress = lib.mkOption {
      type = lib.types.str;
      example = "10.0.30.2/24";
      description = "baradur's static CIDR address on the worker VLAN (must be /24).";
    };
    tftpRoot = lib.mkOption {
      type = lib.types.path;
      default = "/srv/netboot";
    };
    rootStore = lib.mkOption {
      type = lib.types.path;
      example = "/mnt/node/netboot-roots";
      description = "Directory holding per-host netboot root artifacts (NFS-exported ro).";
    };
    pvcExport = lib.mkOption {
      type = lib.types.path;
      example = "/mnt/node/k8s-pvcs";
      description = "Directory exported rw for the k8s NFS StorageClass.";
    };
    clients = lib.mkOption {
      default = { };
      description = "Known Pi netboot clients keyed by hostname.";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          serial = lib.mkOption { type = lib.types.str; };
          mac = lib.mkOption { type = lib.types.str; };
          address = lib.mkOption {
            type = lib.types.str;
            description = "UniFi-reserved IP for this Pi.";
          };
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = prefix == 24;
        message = "fellowship.netboot: NFS ACL / proxy-DHCP derivation supports only a /24 serverAddress.";
      }
      {
        # workers egress via UniFi, not baradur; NAT here would route them into wg0 (full-tunnel).
        assertion = !config.networking.nat.enable;
        message = "fellowship.netboot: do NOT enable NAT — workers egress via UniFi, not baradur (wg0 full-tunnel).";
      }
    ];

    # Build aarch64 Pi closures on this x86_64 host via qemu emulation.
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Scripted VLAN sub-iface with a static address; keep dhcpcd off it.
    # baradur uses scripted (dhcpcd) networking — NOT NetworkManager, NOT systemd-networkd.
    networking.vlans.${vlanIface} = {
      id = cfg.vlan;
      interface = cfg.parentInterface;
    };
    networking.interfaces.${vlanIface} = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = hostIp;
          prefixLength = prefix;
        }
      ];
    };
    networking.dhcpcd.denyInterfaces = [ vlanIface ];

    # Proxy-DHCP (coexists with UniFi DHCP) + TFTP, bound to the VLAN iface.
    services.dnsmasq = {
      enable = true;
      settings = {
        interface = vlanIface;
        bind-interfaces = true;
        port = 0; # DHCP + TFTP only, no DNS
        dhcp-range = [ "${netAddr},proxy" ];
        dhcp-match = [ "set:rpi,option:client-arch,0" ];
        pxe-service = [ "tag:rpi,0,Raspberry Pi Boot" ];
        enable-tftp = true;
        tftp-root = toString cfg.tftpRoot;
        tftp-unique-root = "mac"; # serve <tftpRoot>/<mac>/ per client (pair with EEPROM TFTP_PREFIX=1)
        log-dhcp = true;
      };
    };
    # Order dnsmasq after the VLAN device exists (systemd keeps the literal dot in NIC unit names).
    systemd.services.dnsmasq.after = [
      "network.target"
      "sys-subsystem-net-devices-${vlanIface}.device"
    ];

    # NFSv4-only: the worker netboot root (ro) and the PVC store (rw, root-squashed).
    services.nfs.server = {
      enable = true;
      extraNfsdConfig = "vers3=n"; # disable NFSv3 → only TCP 2049 needed
      exports = ''
        ${toString cfg.rootStore} ${netAddr}/${toString prefix}(ro,sync,no_subtree_check,no_root_squash,fsid=0)
        ${toString cfg.pvcExport} ${netAddr}/${toString prefix}(rw,sync,no_subtree_check,root_squash)
      '';
    };

    networking.firewall.interfaces.${vlanIface} = {
      allowedUDPPorts = [
        67 # DHCP
        69 # TFTP
        4011 # proxy-DHCP
      ];
      allowedTCPPorts = [ 2049 ]; # NFSv4
    };

    systemd.tmpfiles.rules = [
      "d ${toString cfg.tftpRoot} 0755 dnsmasq dnsmasq - -"
      "d ${toString cfg.rootStore} 0755 root root - -"
      "d ${toString cfg.pvcExport} 0777 root root - -"
    ];
  };
}
