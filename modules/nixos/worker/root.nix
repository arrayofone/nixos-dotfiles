{ lib, config, namespace, ... }:
let
  cfg = config.${namespace}.worker;
  nicModule = if cfg.board == "pi5" then "macb" else "bcmgenet";
  ec = cfg.root.extraConfig;
in
{
  config = lib.mkIf cfg.enable (lib.mkMerge [

    # ---- local: on-disk root; the flake's extlinux/uboot handles boot ----
    (lib.mkIf (cfg.root.mode == "local") {
      fileSystems."/" = {
        device = cfg.root.target;
        fsType = ec.fsType or "ext4";
      };
    })

    # ---- nfs: KERNEL-driven NFS root (busybox stage-1 has no mount.nfs) ----
    # HARDWARE-VALIDATE: kernel root=/dev/nfs vs stage-1 mount interplay; v3 vs v4.1 on the RPi
    # initrd. v3+nolock is the documented-working path. The Taskfile derives cmdline.txt from
    # these kernelParams for the netboot config.
    (lib.mkIf (cfg.root.mode == "nfs") {
      boot.initrd.availableKernelModules = [ nicModule ]; # NIC for kernel ip= autoconfig
      boot.kernelParams = [
        "ip=dhcp"
        "root=/dev/nfs"
        "nfsroot=${cfg.root.target},vers=3,tcp,nolock"
        "ro"
        "rootwait"
      ];
      fileSystems."/" = {
        device = cfg.root.target;
        fsType = "nfs";
        options = [ "vers=3" "tcp" "nolock" "ro" ];
      };
    })

    # ---- ram: TFTP-loaded ramdisk via upstream netbootRamdisk ----
    # The OS root lives ENTIRELY in the initrd (store squashfs bundled in), TFTP-loaded — no
    # runtime NFS, so a baradur reboot can't touch a running node. The HOST must import
    # `installer/netboot/netboot.nix` (imports can't be gated on an option), which OWNS
    # fileSystems."/" (tmpfs) + /nix/.ro-store. This branch only adds the runtime NIC module.
    (lib.mkIf (cfg.root.mode == "ram") {
      boot.initrd.availableKernelModules = [ nicModule ];
    })
  ]);
}
