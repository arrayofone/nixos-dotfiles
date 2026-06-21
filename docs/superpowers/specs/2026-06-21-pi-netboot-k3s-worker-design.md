# Diskless Raspberry Pi k3s Worker — Netbooted from baradur

- **Date:** 2026-06-21
- **Status:** Design approved, pending spec review
- **Repo:** `fellowship` dotfiles (Snowfall-lib, namespace `fellowship`, nixpkgs unstable)

## 1. Goal

Stand up one or more **diskless Raspberry Pi worker nodes** that **network-boot (no SD
card as a boot device)** and run a **small modern Kubernetes cluster (k3s)**. There is no
dedicated PXE appliance, so the existing x86_64 workstation **baradur** doubles as the
boot + storage server.

- **Primary node:** Raspberry Pi 4 (≥ 4 GB) → new host `worker`, runs k3s as a **server**
  (control plane + worker combined).
- **Second node (later):** Raspberry Pi 5 → the existing `systems/aarch64-linux/agent`
  stub is migrated to the same profile and joins as a k3s **agent**.
- **Bonus:** the running Pi can register as a native aarch64 Nix remote builder for baradur.

## 2. Constraints & decisions (from brainstorming)

| Topic | Decision |
| --- | --- |
| Pi netboot mechanism | Pi has **no real PXE/UEFI** — its boot ROM does **TFTP**, then a network root. "PXE server" concretely = **DHCP-proxy + TFTP + NFS** on baradur. |
| Network | Workers live on a **separate UniFi-managed VLAN**; baradur sits on the trusted VLAN and gets a **tagged sub-interface** on the worker VLAN. UniFi keeps DHCP + inter-VLAN routing. |
| DHCP | baradur runs **dnsmasq in proxy-DHCP mode** (answers boot options only; never leases) so it coexists with UniFi DHCP and sidesteps RPi DHCP-option quirks. |
| Root delivery | A first-class **`rootMode` flag**: `ram` (default) / `nfs` / `local`. |
| k3s system state | The k3s datastore + containerd image store need a **real block filesystem** (containerd overlayfs + etcd/SQLite are unreliable on NFS). Lives on a **local SD or USB device** mounted at `/var/lib/rancher/k3s`. The SD is a **data disk only**, never a boot device. |
| Workload PVCs | baradur's spare multi-TB storage is served as an **NFS StorageClass** inside k8s. **Not Ceph** (single-node Ceph is overkill and doesn't solve the containerd-on-NFS constraint; revisit Rook-Ceph only if the cluster grows to multi-node storage). |
| Build path | baradur is x86_64; a diskless node can't build itself → baradur enables **`boot.binfmt.emulatedSystems = ["aarch64-linux"]`** (qemu) to build Pi closures. Live Pi later becomes a native remote builder. |
| RPi support | Add one real flake input (**`nixos-raspberrypi`**) for Pi 4/5 firmware + kernel + DTBs, replacing `agent`'s impure `fetchTarball`. |
| Secrets | Keep `fellowship.secrets` (sops). The **local state device also persists node identity** (`/etc/ssh` host keys + `/var/lib/sops-nix`) so decryption is stable across reboots. |

## 3. Architecture

```
  UniFi gateway ── routes/firewalls between VLANs, runs DHCP per VLAN
        │
   ┌────┴───────────────── trusted VLAN ──────────────────┐
   │  baradur (x86_64)                                     │
   │   • NetworkManager on its normal trusted-VLAN IP      │
   │   • tagged sub-iface on WORKER VLAN  (enp42s0.<id>)   │
   │       ├─ dnsmasq  → proxy-DHCP (boot opts only) + TFTP│
   │       ├─ NFS export: squashfs root image (read-only)  │
   │       ├─ NFS export: spare TB → k3s PVC StorageClass  │
   │       └─ binfmt aarch64 emulation (builds Pi closures)│
   └──────────────────────┬───────────────────────────────┘
                  worker VLAN (UniFi-managed)
                          │
            ┌─────────────┴───────────────┐
        Pi 4 "worker"               Pi 5 "agent" (later)
         • EEPROM: netboot first      • same profile, joins
         • k3s SERVER (cp+worker)       as k3s agent
         • SD/USB = /var/lib/rancher/k3s + node identity (state only)
```

### Boot sequence (no SD boot)

1. **EEPROM netboot** — Pi 4 firmware sends a DHCP request tagged as a Pi. UniFi leases an
   IP; baradur's **dnsmasq (proxy mode)** answers with TFTP server = baradur + the Pi's
   per-serial boot directory.
2. **TFTP** — Pi pulls firmware + `config.txt`/`cmdline.txt` + **kernel + DTB + initrd**
   from `/srv/netboot/<serial>/` on baradur.
3. **initrd** — brings up eth0, then per `rootMode`:
   - `ram`: **fetches the squashfs root over NFS/HTTP and copies it into RAM**, pivots.
   - `nfs`: mounts the NFS export **live** as a read-only root + tmpfs overlay.
   - `local`: (not netbooted) boots from the local block device.
4. **systemd** — `services.k3s` starts (`server` or `agent`); `/var/lib/rancher/k3s` is
   bind-mounted onto the **local block device** so containerd overlayfs works and cluster
   state survives baradur reboots.
5. **PVCs** — workloads get persistent volumes from baradur's spare TB via an **NFS
   StorageClass**.

**Resilience consequence:** a baradur reboot blocks *new* Pi boots and pauses NFS-backed
PVCs, but a `ram`-mode node already up keeps running with local state intact. Worker
internet egress is via the **UniFi gateway on the worker VLAN**, never through baradur, so
baradur's full-tunnel WireGuard is irrelevant to the workers.

## 4. Components (repo surface)

Follows existing conventions: `options.${namespace}.<name>`, `let cfg = config.${namespace}.<name>`,
`config = lib.mkIf cfg.enable { ... }`, `lib` helpers `mkOpt`/`mkBoolOpt`, split
`hardware-configuration.nix`.

### A. `modules/nixos/netboot/` → `fellowship.netboot` (server side, on baradur)

```nix
fellowship.netboot = {
  enable          = true;
  parentInterface = "enp42s0";        # baradur's physical NIC
  vlan            = 30;               # UniFi worker-VLAN id → enp42s0.30
  serverAddress   = "10.0.30.2/24";   # baradur's static IP on the worker VLAN
  tftpRoot        = "/srv/netboot";   # per-serial boot dirs
  rootStore       = "/mnt/node/netboot-roots";  # squashfs images (RAID)
  pvcExport       = "/mnt/node/k8s-pvcs";        # spare TB → NFS StorageClass
  clients = {
    worker = { serial = "<pi4-serial>"; mac = "dc:a6:32:xx:xx:xx"; };
    # agent = { serial = "<pi5-serial>"; mac = "..."; };   # added later
  };
};
```

Wires (all bound to the VLAN interface): **dnsmasq** (proxy-DHCP + TFTP), **NFS exports**
(root images + PVC store), the **tagged VLAN sub-interface** via systemd-networkd (NM keeps
the trusted-VLAN IP; networkd owns only the tagged sub-iface), **firewall** openings
(69/udp TFTP, 2049 NFS, 67 + 4011 proxy-DHCP) + adds the iface to `trustedInterfaces`, and
**`boot.binfmt.emulatedSystems = ["aarch64-linux"]`**. Assertion: dnsmasq must remain in
proxy mode (no IP leasing) to avoid competing with UniFi DHCP.

### B. `modules/nixos/worker/` → `fellowship.worker` (the Pi profile, reusable Pi 4/5)

```nix
fellowship.worker = {
  enable = true;

  root = {
    mode   = "ram";   # ram | nfs | local   (default: ram)

    # `target` is interpreted per-mode:
    #   ram   → NFS/HTTP source of the squashfs to copy into RAM
    #   nfs   → NFS export mounted live as the read-only root
    #   local → block device to boot from
    target = "10.0.30.2:/mnt/node/netboot-roots/worker";

    # freeformType passthrough — merged verbatim into the generated fileSystems/initrd:
    extraConfig = {
      fetch        = "nfs";          # ram: nfs | http
      overlaySize  = "75%";          # ram/nfs: tmpfs overlay sizing
      mountOptions = [ "ro" "noatime" ];
    };
  };

  k3s = {
    role        = "server";          # server (cp+worker) | agent (join only)
    target      = null;              # agent: server URL (e.g. https://10.0.30.x:6443)
    stateDevice = "/dev/disk/by-label/K3S_STATE";  # → /var/lib/rancher/k3s + node identity
    extraConfig = { };               # freeform → extra k3s flags / config
  };
};
```

Drives, off the single `root.mode` value, the `fileSystems`/`initrd` strategy; configures
`services.k3s` with the right role/flags; bind-mounts `/var/lib/rancher/k3s`, `/etc/ssh`,
and `/var/lib/sops-nix` onto `stateDevice`; and installs the in-cluster NFS provisioner
client pointed at `netboot.pvcExport`. The `target` + `extraConfig` shape is mirrored on
both `root` and `k3s` so each subsystem has an escape hatch instead of a closed knob set.

### C. Hosts

- New `systems/aarch64-linux/worker/` (Pi 4) — enables `fellowship.worker` with
  `root.mode = "ram"`, `k3s.role = "server"`. `home.enable = false` (headless pattern, per
  `helms-deep`).
- Existing `systems/aarch64-linux/agent/` (Pi 5) — later switched to
  `fellowship.worker = { root.mode = "ram"; k3s.role = "agent"; k3s.target = "https://<worker-ip>:6443"; }`.
- `helms-deep` untouched.

### D. Secrets / sops

- Add `worker` (and later `agent`) to `.sops.yaml`; create `secrets/worker.yaml` holding the
  **k3s join token** and any NFS creds.
- Node identity (`/etc/ssh/ssh_host_ed25519_key`, `/var/lib/sops-nix/key.txt`) persists on
  `stateDevice`; generated once during the `local` bootstrap boot, its age pubkey added to
  `.sops.yaml`.

## 5. Build, bootstrap & deploy

- **RPi flake input:** add `nixos-raspberrypi` for Pi 4/5 firmware + kernel + DTBs.
- **Artifacts per mode:** from the worker host config — `ram`/`nfs` → kernel + initrd + DTB
  + firmware (→ TFTP dir) and a store **squashfs** (→ NFS `rootStore`); `local` → an
  `sdImage` written once.
- **Deploy:** a `Taskfile` target `task netboot:worker` builds (emulated) and **populates
  baradur's `/srv/netboot/<serial>/` and `rootStore/worker/` locally** (baradur is both
  builder and server — no scp).
- **Bootstrap order (one-time):**
  1. **UniFi:** create the worker VLAN, tag baradur's link, place the Pi's port on the VLAN.
  2. `nixos-rebuild switch` baradur → boot services + binfmt come up.
  3. Read the Pi **serial** (dnsmasq logs it on first netboot attempt) → fill
     `clients.worker.serial`.
  4. `task netboot:worker` → build + populate.
  5. **Set Pi 4 EEPROM to network-boot-first** (`rpi-eeprom-config`) — easiest via a
     throwaway `root.mode = "local"` boot, which also proves the host config before going
     diskless. (The one unavoidable physical step.)
  6. Power-cycle → netboots into RAM, k3s starts.

## 6. Failure modes & mitigations

- **baradur down** — `ram`: running node survives (OS in RAM, k3s state local); new boots +
  NFS PVCs pause. `nfs`: node root I/O stalls. `local`: independent. (Resilience:
  `local` > `ram` ≫ `nfs`; hence `ram` default.)
- **State device failure** — cluster state lost (PVC data on baradur survives). Mitigation:
  `k3s etcd-snapshot` cron → baradur NFS.
- **DHCP collision** — dnsmasq stays in proxy mode, bound to the VLAN iface; module
  assertion enforces it.
- **Inter-VLAN rules** — UniFi must allow worker→baradur (TFTP 69/udp, NFS 2049) and
  worker→WAN (image pulls) via the UniFi gateway. Documented as part of Phase 1.
- **Emulated build slowness** — mitigate by registering the live Pi as a remote builder and
  using a binary cache.

## 7. Testing ladder

The `rootMode` flag *is* the de-risking path:

1. `local` — prove host config + k3s server + state device + sops identity on-disk.
2. `nfs` — prove the netboot chain (TFTP + initrd + NFS) with fast iteration (no squashfs
   rebuild per change).
3. `ram` — final resilient default.

Verify at each step: `kubectl get nodes` Ready; reboot baradur and confirm a `ram` node
stays up; create a PVC and confirm the NFS StorageClass binds.

## 8. Phased rollout

- **Phase 0** — `nixos-raspberrypi` input + module scaffolding (`fellowship.netboot`,
  `fellowship.worker`); `nixos-rebuild build` to typecheck.
- **Phase 1** — baradur server side: enable `fellowship.netboot`, switch baradur, configure
  UniFi VLAN, verify dnsmasq/TFTP/NFS/VLAN up.
- **Phase 2** — Pi 4 in `local` mode: prove k3s server + state device + secrets identity.
- **Phase 3** — flip to `nfs` mode: prove the netboot chain.
- **Phase 4** — flip to `ram` mode: resilient default; baradur-reboot survival test.
- **Phase 5** — Pi 5 `agent` joins (migrate the `agent` host onto the worker profile).
- **Phase 6 (optional)** — Pi-as-remote-builder; NFS StorageClass + sample PVC; etcd
  snapshot cron.

## 9. Open questions / future

- Exact UniFi VLAN id + subnet (placeholders `30` / `10.0.30.0/24` used above).
- Pi serials + MACs (filled during bootstrap).
- HA control plane (embedded etcd needs 3 servers) — out of scope for a 1–2 node start.
- Rook-Ceph for replicated storage — only if the cluster grows to multi-node storage.
