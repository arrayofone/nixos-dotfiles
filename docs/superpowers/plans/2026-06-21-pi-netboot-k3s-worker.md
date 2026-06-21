# Diskless Raspberry Pi k3s Worker — Implementation Plan (Revision 2)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **Revision 2.1** — rewritten after a 5-agent adversarial review + fact-verification, then hardened again after a 3-agent **re-review**. The re-review verified (at pinned-nixpkgs source level) that the Nix/secrets/networking/NFS layers are correct; it found the **boot chain still unbootable**, so the boot mechanics were redesigned in this revision. Findings are tagged inline as `[fix: Cn/Hn]` (round 1) and `[fix: re#n]` (re-review).
>
> **Re-review verdict to keep in mind:** RPi diskless NixOS netboot cannot be fully resolved on paper — the boot chain (Tasks 4, 7, 9, 10) is the **hardware bring-up frontier**. The `local → nfs → ram` ladder front-loads the provable parts; treat the `nfs`/`ram` mechanics as designs to validate on the real Pi, not settled facts.
>
> **v2.1 changelog (applied from re-review):** `nfs` mode → kernel `root=/dev/nfs` path (no userspace `mount.nfs`, which busybox lacks) `[re#F1/F4]`; `ram` mode → upstream `installer/netboot/netboot.nix` `netbootRamdisk` via host-level import (the whole-root-squashfs-over-NFS design was invalid) `[re#F1/F2]`; firmware tree now generates `config.txt` and hard-asserts it `[re#F5]`; k3s server gets `--write-kubeconfig-mode=0600` `[re#B3/H2]` and `--cluster-init` so etcd snapshots work `[re#3]`; fixed `systemd…after` dot-escaping `[re#F3]`; added a runbook-creation task `[re#B6]`; SSH access for kubeconfig fetch `[re#B2]`; `worker.enable` added to the inertness check `[re#B9]`.

**Goal:** Network-boot one or more diskless Raspberry Pi worker nodes (no SD boot device) from baradur and run a k3s cluster on them.

**Architecture:** baradur (x86_64, **scripted/dhcpcd networking**) gains a `fellowship.netboot` module that serves proxy-DHCP + TFTP + NFS on a **scripted VLAN sub-interface** of a UniFi-managed worker VLAN, and builds aarch64 closures via binfmt emulation. Each Pi runs a `fellowship.worker` profile whose `root.mode` flag (`ram` | `nfs` | `local`) selects how the OS root is delivered. The Pi firmware + kernel + initrd come from `nixos-raspberrypi` (vendor firmware via `pkgs.raspberrypifw`); k3s state + node identity live on a local block device (`K3S_STATE`); workload PVCs come from baradur over NFS.

**Tech Stack:** NixOS (nixpkgs unstable), Snowfall-lib (namespace `fellowship`), home-manager, sops-nix, `nixos-raspberrypi` (`github:nvmd/nixos-raspberrypi`), dnsmasq (proxy-DHCP + TFTP), NFSv4, scripted networking (`networking.vlans`), k3s, `csi-driver-nfs`.

## Global Constraints

- Snowfall namespace is `fellowship`; options are `options.${namespace}.<name>`, gated `config = lib.mkIf cfg.enable { ... }`. Module args `{ lib, config, pkgs, namespace, ... }`. Repo `lib` helpers: `mkOpt`, `mkBoolOpt`, `enabled`, `disabled`.
- `modules/nixos/secrets` and `modules/nixos/fonts` are **always-on** (no enable gate). A new host needs a matching `secrets/<hostname>.yaml` (encrypted to that host's age key) and a `.sops.yaml` rule, **or eval/activation fails**. The host SSH key is **pre-seeded** (see Phase 2) to avoid the first-boot circularity. `[fix: C9]`
- Headless host pattern (`helms-deep`): `snowfallorg.users.arrayofone.home.enable = false`.
- Commits are **GPG-signed**, **no `Co-Authored-By`**, message `type(scope) subject` (no colon after scope).
- `system.stateVersion = "24.05"`, locale `en_CA.UTF-8`, tz `America/Vancouver`. The worker module sets these with **`lib.mkDefault`** so host files can override without conflict. `[fix: B5]`
- baradur uses **scripted (dhcpcd) networking** — **not** NetworkManager and **not** systemd-networkd. The netboot module uses scripted `networking.vlans`/`networking.interfaces`; it must NOT enable systemd-networkd. `[fix: C11]`
- `nixos-raspberrypi` base modules use **scripted stage-1** (`boot.initrd.systemd.enable = false`) and declare **no** `fileSystems`. Verified at flake rev `16d0e780`.
- Per-board facts: **Pi 4** NIC `bcmgenet`, DTB `bcm2711-rpi-4-b.dtb`, default bootloader `uboot`+extlinux. **Pi 5** NIC `macb`, DTB `bcm2712-rpi-5-b.dtb`, bootloader `kernelboot`/`kernel`. `[fix: F9]`

---

## File Structure

| File | Responsibility |
| --- | --- |
| `flake.nix` (modify) | Add `nixos-raspberrypi` input; inject `raspberry-pi-4.base` into `worker`, `raspberry-pi-5.base` into `agent`; for `ram` hosts also inject upstream `installer/netboot/netboot.nix`. |
| `modules/nixos/netboot/default.nix` (create) | `fellowship.netboot` — scripted VLAN iface, dnsmasq (proxy-DHCP + TFTP), NFSv4 exports, firewall, binfmt, no-NAT assertion. |
| `modules/nixos/worker/default.nix` (create) | `fellowship.worker` — options (`board`, `root`, `k3s`, `bootServer`), k3s via `mkMerge`, `/state` device + binds, board-derived NIC module. |
| `modules/nixos/worker/root.nix` (create) | `root.mode` → fileSystems/initrd/kernelParams (ram/nfs/local). |
| `systems/aarch64-linux/worker/{default,hardware-configuration}.nix` (create) | Pi 4 host. |
| `systems/aarch64-linux/agent/default.nix` (modify, Phase 5) | Pi 5 host onto `fellowship.worker` as agent. |
| `systems/x86_64-linux/baradur/default.nix` (modify) | Enable `fellowship.netboot`. |
| `.sops.yaml` + `secrets/k3s-cluster.yaml` (modify/create) | Shared k3s token via a **key group** (worker+agent+operator). `[fix: G2]` |
| `secrets/worker.yaml`, `secrets/agent.yaml` (create) | Per-host password (matches the always-on module's `system/users/...` secret). |
| `Taskfile.yml` (modify) | Parameterized `netboot:host HOST=… SERIAL=…` build+populate target. `[fix: C7]` |
| `docs/superpowers/plans/2026-06-21-pi-netboot-runbook.md` (create) | UniFi steps, per-mode deploy loop, brick recovery, kubeconfig retrieval. |

---

## Deploy model (read before executing — referenced by every phase) `[fix: C10]`

The deploy loop **differs by `root.mode`**. Never `nixos-rebuild switch` on a Pi in `nfs`/`ram` mode — the root is read-only NFS or a RAM overlay, so the change either fails or is silently lost on reboot.

- **`local`** — build + `nixos-rebuild switch --flake .#<host>` **on the Pi** (normal on-disk install).
- **`nfs` / `ram`** — config changes are applied on **baradur**: `task netboot:host HOST=<host> SERIAL=<serial>` rebuilds the aarch64 closure, repopulates `/srv/netboot/<serial>/<generation>/`, atomically flips the `current` symlink, then you **power-cycle the Pi**. The Pi never runs `switch`.

**Brick recovery `[fix: H6]`:** set the Pi EEPROM `BOOT_ORDER=0xf21` (SD first, then network) and keep a known-good `local` SD inserted. A bad netboot image → pull power, the Pi falls back to SD; or flip the `current` symlink back to the previous generation and power-cycle.

---

## Phase 0 — Flake input & module scaffolding

### Task 1: Add the `nixos-raspberrypi` flake input

**Files:** Modify `flake.nix`.

- [ ] **Step 1: Add the input** (do NOT force `inputs.nixpkgs.follows` — it pins a tested nixpkgs/firmware pair `[fix: R3]`):

```nix
nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
```

- [ ] **Step 2: Inject the verified module attr** into the worker host (snowfall `systems.hosts`, where `baradur` already lists `modules`):

```nix
worker.modules = with inputs; [ nixos-raspberrypi.nixosModules.raspberry-pi-4.base ];
# agent.modules added in Phase 5 with raspberry-pi-5.base
```

- [ ] **Step 3: Verify the flake locks and evaluates.**

Run: `nix flake lock 2>&1 | tail -3 && nix eval .#nixosConfigurations.baradur.config.system.stateVersion 2>&1 | tail -3`
Expected: `nixos-raspberrypi` added to `flake.lock`; baradur still evaluates (`"24.05"`). The `worker` host doesn't exist yet, so don't eval it.

- [ ] **Step 4: Commit.**

```bash
git add flake.nix flake.lock
git commit -m "feat(flake) add nixos-raspberrypi input for diskless pi worker"
```

### Task 2: Scaffold both modules as inert stubs

**Files:** Create `modules/nixos/netboot/default.nix`, `modules/nixos/worker/default.nix`, `modules/nixos/worker/root.nix`.

- [ ] **Step 1: netboot stub** — options + `config = lib.mkIf cfg.enable { }`:

```nix
{ lib, config, namespace, ... }:
let cfg = config.${namespace}.netboot;
in {
  options.${namespace}.netboot.enable =
    lib.mkEnableOption "diskless Pi netboot server (proxy-DHCP + TFTP + NFS)";
  config = lib.mkIf cfg.enable { };
}
```

- [ ] **Step 2: worker stub** (imports `root.nix`):

```nix
{ lib, config, namespace, ... }:
let cfg = config.${namespace}.worker;
in {
  imports = [ ./root.nix ];
  options.${namespace}.worker.enable = lib.mkEnableOption "diskless k3s worker profile";
  config = lib.mkIf cfg.enable { };
}
```

- [ ] **Step 3: root stub:** `{ lib, config, namespace, ... }: let cfg = config.${namespace}.worker; in { config = lib.mkIf cfg.enable { }; }`

- [ ] **Step 4: Prove inertness on ALL existing hosts** (the modules are auto-imported everywhere) `[fix: G9]`:

Run: `for h in baradur helms-deep agent; do for m in netboot worker; do nix eval .#nixosConfigurations.$h.config.fellowship.$m.enable; done; done`  `[fix: re#B9]`
Expected: `false` six times, no eval errors (both stubs inert on every existing host).

- [ ] **Step 5: Commit.** `git add modules/nixos/netboot modules/nixos/worker && git commit -m "feat(worker) scaffold netboot and worker module stubs"`

---

## Phase 1 — baradur server side

### Task 3: `fellowship.netboot` options + scripted VLAN + binfmt + no-NAT assertion

**Files:** Modify `modules/nixos/netboot/default.nix`.

**Interfaces — Produces:** options `parentInterface:str`, `vlan:int`, `serverAddress:str` (CIDR), `tftpRoot:path=/srv/netboot`, `rootStore:path`, `pvcExport:path`, `clients:attrsOf {serial:str; mac:str; address:str;}`. Computed: `vlanIface`, `hostIp`, `prefix`, `netAddr` consumed by Tasks 4–5.

- [ ] **Step 1: Options + scripted VLAN + binfmt.** `[fix: C11]`

```nix
{ lib, config, pkgs, namespace, ... }:
let
  cfg = config.${namespace}.netboot;
  vlanIface = "${cfg.parentInterface}.${toString cfg.vlan}";
  hostIp = lib.head (lib.splitString "/" cfg.serverAddress);
  prefix = lib.toInt (lib.last (lib.splitString "/" cfg.serverAddress));
  octets = lib.splitString "." hostIp;
  netAddr = "${lib.concatStringsSep "." (lib.take 3 octets)}.0";   # /24 only — asserted below
in {
  options.${namespace}.netboot = {
    enable = lib.mkEnableOption "diskless Pi netboot server (proxy-DHCP + TFTP + NFS)";
    parentInterface = lib.mkOption { type = lib.types.str; example = "enp42s0"; };
    vlan = lib.mkOption { type = lib.types.int; example = 30; };
    serverAddress = lib.mkOption { type = lib.types.str; example = "10.0.30.2/24"; };
    tftpRoot = lib.mkOption { type = lib.types.path; default = "/srv/netboot"; };
    rootStore = lib.mkOption { type = lib.types.path; example = "/mnt/node/netboot-roots"; };
    pvcExport = lib.mkOption { type = lib.types.path; example = "/mnt/node/k8s-pvcs"; };
    clients = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule { options = {
        serial = lib.mkOption { type = lib.types.str; };
        mac = lib.mkOption { type = lib.types.str; };
        address = lib.mkOption { type = lib.types.str; description = "UniFi-reserved IP."; };
      }; });
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = prefix == 24;
        message = "fellowship.netboot: NFS ACL/proxy-DHCP derivation supports only a /24 serverAddress."; }
      { assertion = !config.networking.nat.enable;
        message = "fellowship.netboot: do NOT enable NAT — workers egress via UniFi, not baradur (wg0 is full-tunnel)."; }  # [fix: G6/R6]
    ];

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];   # [fix: H8 — see runbook for build-time caveat]

    # Scripted VLAN sub-iface with a static address; dhcpcd must not touch it.  [fix: C11]
    networking.vlans.${vlanIface} = { id = cfg.vlan; interface = cfg.parentInterface; };
    networking.interfaces.${vlanIface} = {
      useDHCP = false;
      ipv4.addresses = [ { address = hostIp; prefixLength = prefix; } ];
    };
    networking.dhcpcd.denyInterfaces = [ vlanIface ];
  };
}
```

- [ ] **Step 2: Temporarily enable on baradur** (end of `systems/x86_64-linux/baradur/default.nix`), with real values once known:

```nix
fellowship.netboot = {
  enable = true;
  parentInterface = "enp42s0";   # confirm in hardware-configuration.nix
  vlan = 30;                      # real UniFi worker-VLAN id
  serverAddress = "10.0.30.2/24";
  rootStore = "/mnt/node/netboot-roots";
  pvcExport = "/mnt/node/k8s-pvcs";
};
```

- [ ] **Step 3: Verify build + the VLAN iface resolves.**

Run: `nix eval .#nixosConfigurations.baradur.config.networking.vlans --apply 'builtins.attrNames'`
Expected: list containing `"enp42s0.30"`.
Run: `nixos-rebuild build --flake .#baradur 2>&1 | tail -5`
Expected: clean build.

- [ ] **Step 4: Commit.** `git add modules/nixos/netboot/default.nix systems/x86_64-linux/baradur/default.nix && git commit -m "feat(netboot) scripted vlan iface, binfmt and no-nat guard"`

### Task 4: dnsmasq proxy-DHCP that actually answers + TFTP `[fix: C3/G3]`

**Files:** Modify `modules/nixos/netboot/default.nix` (extend `config`).

- [ ] **Step 1: Add dnsmasq + TFTP + firewall + tmpfiles** — single assignments to avoid duplicate-key eval errors `[fix: C8]`:

```nix
    services.dnsmasq = {
      enable = true;
      settings = {
        interface = vlanIface;
        bind-interfaces = true;
        port = 0;                                   # DHCP+TFTP only, no DNS
        dhcp-range = [ "${netAddr},proxy" ];        # proxy on the SUBNET, not the host IP  [fix: G3]
        dhcp-match = [ "set:rpi,option:client-arch,0" ];
        pxe-service = [ "tag:rpi,0,Raspberry Pi Boot" ];   # the actionable proxy reply  [fix: C3]
        enable-tftp = true;
        tftp-root = toString cfg.tftpRoot;
        tftp-unique-root = "mac";                   # serve <tftpRoot>/<mac>/ per client
        log-dhcp = true;
      };
    };
    # dnsmasq binds the iface at start; order after the VLAN device exists.  [fix: re#F3]
    # systemd does NOT escape the dot in a NIC device unit — use the literal name.
    systemd.services.dnsmasq.after = [ "network.target" "sys-subsystem-net-devices-${vlanIface}.device" ];

    # NFSv4-only firewall (see Task 5) + TFTP/DHCP, combined into single assignments:
    networking.firewall.interfaces.${vlanIface} = {
      allowedUDPPorts = [ 67 69 4011 ];   # DHCP, TFTP, proxyDHCP
      allowedTCPPorts = [ 2049 ];          # NFSv4 (added in Task 5; declared once here)
    };

    systemd.tmpfiles.rules = [
      "d ${toString cfg.tftpRoot} 0755 dnsmasq dnsmasq - -"
      "d ${toString cfg.rootStore} 0755 root root - -"
      "d ${toString cfg.pvcExport} 0777 root root - -"
    ];
```

> **ON-HARDWARE TUNABLE `[fix: C3/F4/F7]`:** the RPi4 proxy-DHCP/TFTP handshake is firmware-version-sensitive. `tftp-unique-root=mac` maps each Pi to `<tftpRoot>/<mac>/`; this must match the EEPROM `TFTP_PREFIX` (default 0 = no prefix; set `TFTP_PREFIX=1` for MAC, `=2` for serial). Confirm with `journalctl -u dnsmasq -f` during a boot attempt, and ensure **UniFi "Network Boot" is OFF** for this VLAN (else two boot responders collide) while UniFi DHCP stays **ON**. Requires L2 adjacency between the Pi's port and baradur's VLAN sub-iface.

- [ ] **Step 2: Build.** `nixos-rebuild build --flake .#baradur 2>&1 | tail -5` → clean.
- [ ] **Step 3: Commit.** `git add modules/nixos/netboot/default.nix && git commit -m "feat(netboot) proxy-dhcp pxe reply and tftp via dnsmasq"`

### Task 5: NFSv4 exports — root store (ro) + PVC store (rw, squashed) `[fix: H1/H3/E4]`

**Files:** Modify `modules/nixos/netboot/default.nix` (extend `config`).

- [ ] **Step 1: NFSv4-only server; `root_squash` on the rw export; drop `trustedInterfaces`.**

```nix
    services.nfs.server = {
      enable = true;
      # NFSv4 only → only port 2049 needed, no rpcbind/mountd/statd random ports.  [fix: H3]
      extraNfsdConfig = "vers3=n";
      exports = ''
        ${toString cfg.rootStore} ${netAddr}/${toString prefix}(ro,sync,no_subtree_check,no_root_squash,fsid=0)
        ${toString cfg.pvcExport} ${netAddr}/${toString prefix}(rw,sync,no_subtree_check,root_squash)
      '';
    };
```

> **SECURITY NOTES:** `no_root_squash` is kept ONLY on the **read-only** root store (store paths must keep root ownership); the **rw** PVC export uses default `root_squash` so a compromised pod-host cannot write setuid-root files to baradur `[fix: H1]`. We deliberately do **not** set `networking.firewall.trustedInterfaces` — the explicit `allowedTCPPorts=[2049]` (Task 4) is the whole exposure, instead of opening baradur's entire service surface (postgres/ftp/ssh) to the VLAN `[fix: E4]`. To tighten further, replace `${netAddr}/${prefix}` on the ro store with the specific `cfg.clients.*.address` IPs.

- [ ] **Step 2: Build + smoke.** `nixos-rebuild build --flake .#baradur 2>&1 | tail -3` → clean.
- [ ] **Step 3: Create the runbook `[fix: re#B6]`.** Write `docs/superpowers/plans/2026-06-21-pi-netboot-runbook.md` capturing the operator-facing procedures the tasks defer to: the UniFi/switch steps below, the per-mode deploy loop, brick recovery (`BOOT_ORDER`/`current` rollback), MAC casing for TFTP, kubeconfig fetch, and the EEPROM steps. (This file is referenced by Tasks 4, 5, 9, 10 and the Deploy-model section — it must exist.)

- [ ] **Step 3b (hardware — Phase-1 prerequisite block, do BEFORE Task 4's switch verify) `[fix: completeness#7]`:** execute:
  1. UniFi: create VLAN-only network "worker" id=`cfg.vlan`, DHCP **on**, Network-Boot **off**. Reserve a static lease per Pi (fills `clients.<h>.address`).
  2. Tag baradur's switch port for the worker VLAN (trusted VLAN stays untagged). Set each **Pi's** switch port to **untagged/access = worker VLAN** (Pi boot ROM emits untagged frames) `[fix: H7]`.
  3. UniFi firewall: allow worker→baradur TCP 2049 + UDP 67/69/4011; worker→WAN for image pulls.
  4. `sudo nixos-rebuild switch --flake .#baradur`. Verify: `systemctl is-active dnsmasq nfs-server` → `active`; `ip -br addr show enp42s0.30` shows the static IP; `exportfs -v` lists both exports.

- [ ] **Step 4: Commit.** `git add modules/nixos/netboot/default.nix docs/superpowers/plans/2026-06-21-pi-netboot-runbook.md && git commit -m "feat(netboot) nfsv4 exports for root store and pvc store"`

---

## Phase 2 — Pi 4 worker in `local` mode (bootstrap + pre-seed identity)

### Task 6: `fellowship.worker` options + k3s + `/state` device + binds `[fix: C5/C6/B2/B4/B5/H2]`

**Files:** Modify `modules/nixos/worker/default.nix`.

**Interfaces — Produces:** `board:enum[pi4 pi5]`, `bootServer:str`, `root.{mode,target,extraConfig}`, `k3s.{role,target,tokenFile,stateDevice,extraConfig}`; computed `nicModule` (pi4→`bcmgenet`, pi5→`macb`) consumed by `root.nix`.

- [ ] **Step 1: Full module.**

```nix
{ lib, config, pkgs, namespace, ... }:
let
  cfg = config.${namespace}.worker;
  nicModule = if cfg.board == "pi5" then "macb" else "bcmgenet";
in {
  imports = [ ./root.nix ];

  options.${namespace}.worker = {
    enable = lib.mkEnableOption "diskless k3s worker profile";
    board = lib.mkOption { type = lib.types.enum [ "pi4" "pi5" ]; default = "pi4"; };
    bootServer = lib.mkOption { type = lib.types.str; example = "10.0.30.2"; };
    authorizedKeys = lib.mkOption {   # operator SSH keys for kubeconfig fetch  [fix: re#B2]
      type = lib.types.listOf lib.types.str; default = [ ];
    };

    root = {
      mode = lib.mkOption { type = lib.types.enum [ "ram" "nfs" "local" ]; default = "ram"; };
      target = lib.mkOption { type = lib.types.str;
        description = "ram/nfs: 'host:/export'; local: block device path."; };
      extraConfig = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
    };

    k3s = {
      role = lib.mkOption { type = lib.types.enum [ "server" "agent" ]; default = "server"; };
      target = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
      tokenFile = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
      stateDevice = lib.mkOption { type = lib.types.str; example = "/dev/disk/by-label/K3S_STATE"; };
      extraConfig = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = cfg.k3s.role == "server" -> cfg.k3s.target == null;
        message = "fellowship.worker: k3s.target must be null for a server."; }
      { assertion = cfg.k3s.role == "agent" -> (cfg.k3s.target != null && cfg.k3s.tokenFile != null);
        message = "fellowship.worker: agents need k3s.target and k3s.tokenFile."; }
    ];

    # Mount the state device ONCE, then bind real subdirs of it.  [fix: C6]
    fileSystems."/state" =
      { device = cfg.k3s.stateDevice; fsType = "ext4"; neededForBoot = true; };
    fileSystems."/etc/ssh" =
      { device = "/state/ssh"; options = [ "bind" ]; neededForBoot = true; };       # identity for sops
    fileSystems."/var/lib/sops-nix" =
      { device = "/state/sops-nix"; options = [ "bind" ]; neededForBoot = true; };
    fileSystems."/var/lib/rancher/k3s" =
      { device = "/state/rancher"; options = [ "bind" ]; };

    # k3s via mkMerge so extraConfig MERGES (not //-clobbers) and types are checked.  [fix: C5]
    services.k3s = lib.mkMerge [
      { enable = true; role = cfg.k3s.role; tokenFile = cfg.k3s.tokenFile; }
      (lib.mkIf (cfg.k3s.role == "agent")  { serverAddr = cfg.k3s.target; })
      (lib.mkIf (cfg.k3s.role == "server") { extraFlags = [
        "--disable=traefik"
        "--write-kubeconfig-mode=0600"   # admin creds not world-readable  [fix: re#B3/H2]
        "--cluster-init"                  # embedded etcd so `etcd-snapshot` works  [fix: re#3]
      ]; })
      cfg.k3s.extraConfig
    ];
    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.k3s.role == "server") [ 6443 ];

    environment.systemPackages = [ pkgs.k3s pkgs.nfs-utils ];
    services.openssh.enable = true;
    # operator SSH for the kubeconfig fetch (Task 8b) — fetch as arrayofone + sudo, no root login.  [fix: re#B2]
    users.users.arrayofone.openssh.authorizedKeys.keys = cfg.authorizedKeys;
    security.sudo.wheelNeedsPassword = lib.mkDefault false;
    snowfallorg.users.arrayofone.home.enable = false;

    # mkDefault so host files / other hosts never conflict.  [fix: B5]
    system.stateVersion = lib.mkDefault "24.05";
    i18n.defaultLocale = lib.mkDefault "en_CA.UTF-8";
    time.timeZone = lib.mkDefault "America/Vancouver";
  };
}
```

- [ ] **Step 2: Commit (eval deferred to Task 7's host).** `git add modules/nixos/worker/default.nix && git commit -m "feat(worker) k3s mkMerge, single state device with binds"`

### Task 7: `root.nix` — three modes (grounded in verified RPi facts) `[fix: C2/C4/F5/F6]`

**Files:** Modify `modules/nixos/worker/root.nix`.

- [ ] **Step 1: Implement the branches.** `local` boots the flake's default extlinux/uboot off the device; `nfs` uses the **kernel** `root=/dev/nfs nfsroot=… ip=dhcp` path (busybox stage-1 has no `mount.nfs`) with the board NIC forced in; `ram` is delivered as a TFTP-loaded `netbootRamdisk` (root in the initrd) via a host-level import (Task 10), so its branch only adds the NIC module.

```nix
{ lib, config, pkgs, namespace, ... }:
let
  cfg = config.${namespace}.worker;
  nicModule = if cfg.board == "pi5" then "macb" else "bcmgenet";
  ec = cfg.root.extraConfig;
in {
  config = lib.mkIf cfg.enable (lib.mkMerge [

    # ---- local: on-disk root; flake's extlinux/uboot handles boot ----
    (lib.mkIf (cfg.root.mode == "local") {
      fileSystems."/" = { device = cfg.root.target; fsType = ec.fsType or "ext4"; };
    })

    # ---- nfs: KERNEL-driven NFS root (busybox stage-1 has no mount.nfs).  [fix: re#F1/F4] ----
    # HARDWARE-VALIDATE: kernel root=/dev/nfs vs stage-1 mount interplay; v3 vs v4.1 on the RPi
    # initrd. v3+nolock is the documented-working path; if v4.1 is required, inject mount.nfs via
    # boot.initrd.extraUtilsCommands (heavier). The Taskfile derives cmdline.txt from these params.
    (lib.mkIf (cfg.root.mode == "nfs") {
      boot.initrd.availableKernelModules = [ nicModule ];   # NIC for kernel ip= autoconfig
      boot.kernelParams = [
        "ip=dhcp" "root=/dev/nfs"
        "nfsroot=${cfg.root.target},vers=3,tcp,nolock" "ro" "rootwait"
      ];
      fileSystems."/" = { device = cfg.root.target; fsType = "nfs";
        options = [ "vers=3" "tcp" "nolock" "ro" ]; };       # declaration; kernel does the mount
    })

    # ---- ram: TFTP-loaded ramdisk via upstream netbootRamdisk.  [fix: re#F1/F2] ----
    # The OS root lives ENTIRELY in the initrd (store squashfs bundled in), TFTP-loaded — no
    # runtime NFS, so a baradur reboot can't touch a running node. The host MUST import
    # `installer/netboot/netboot.nix` (imports can't be gated on an option), which OWNS
    # fileSystems."/" (tmpfs) + /nix/.ro-store. This branch only adds the runtime NIC module.
    (lib.mkIf (cfg.root.mode == "ram") {
      boot.initrd.availableKernelModules = [ nicModule ];   # for k3s/runtime networking, not root
    })
  ]);
}
```

- [ ] **Step 2: Create the Pi 4 host** `systems/aarch64-linux/worker/default.nix` (start in `local` for bootstrap):

```nix
{ config, ... }:
{
  fellowship.worker = {
    enable = true;
    board = "pi4";
    bootServer = "10.0.30.2";
    root = { mode = "local"; target = "/dev/disk/by-label/WORKER_ROOT"; };
    k3s = { role = "server"; stateDevice = "/dev/disk/by-label/K3S_STATE"; };
  };
  networking.hostName = "worker";
}
```

- [ ] **Step 3: Verify it evaluates** (option resolution; full build in Task 8 after binfmt):

Run: `nix eval .#nixosConfigurations.worker.config.fellowship.worker.root.mode`  → `"local"`
Run: `nix eval .#nixosConfigurations.worker.config.services.k3s.role`  → `"server"`

> If this errors with a missing `secrets/worker.yaml`, that's expected — Task 8 creates it; you may temporarily comment the host out or proceed to Task 8 first. `[fix: completeness#8]`

- [ ] **Step 4: Commit.** `git add modules/nixos/worker/root.nix systems/aarch64-linux/worker/default.nix && git commit -m "feat(worker) ram/nfs/local root modes with ip=dhcp and nic modules"`

### Task 8: Pi 4 hardware config + **pre-seeded** sops identity + first `local` build `[fix: C9/H5/B4]`

**Files:** Create `systems/aarch64-linux/worker/hardware-configuration.nix`; modify `.sops.yaml`; create `secrets/worker.yaml`, `secrets/k3s-cluster.yaml`.

> **The first-boot circularity is solved by PRE-SEEDING the host key** (canonical sops-nix bootstrap), not a two-phase activation. We generate the identity on baradur, encrypt the secrets to it, and write it onto `K3S_STATE` before first boot — so the very first activation can decrypt. `generateKey` stays but the **ssh-host-key-derived** identity is canonical. `[fix: C9/H5]`

- [ ] **Step 1: Hardware config — minimal; the RPi module owns kernel/firmware; do NOT redeclare `/var/lib/rancher/k3s`** `[fix: B4/H4]`:

```nix
# systems/aarch64-linux/worker/hardware-configuration.nix
{ lib, ... }:
{
  # raspberry-pi-4.base provides kernel + raspberrypifw firmware + bootloader.
  # State/root device fileSystems are owned by the worker module (Task 6/7). Nothing here.
  networking.useDHCP = lib.mkDefault true;
}
```

- [ ] **Step 2: Pre-seed the host identity on baradur** (before first boot):

```bash
# 1. generate the worker host key
mkdir -p /tmp/worker-seed && ssh-keygen -t ed25519 -N "" -f /tmp/worker-seed/ssh_host_ed25519_key
# 2. derive its age pubkey
AGE=$(nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /tmp/worker-seed/ssh_host_ed25519_key.pub')
echo "worker age key: $AGE"
```

- [ ] **Step 3: `.sops.yaml` — real key + a shared cluster key group** `[fix: G2]`:

```yaml
keys:
  - &worker <AGE-from-step-2>
  - &arrayofone <existing-operator-key>
creation_rules:
  - path_regex: secrets/worker\.yaml$
    key_groups: [ { age: [ *worker ] } ]
  - path_regex: secrets/k3s-cluster\.yaml$        # shared token, one source of truth
    key_groups: [ { age: [ *worker, *arrayofone ] } ]   # *agent added in Phase 5
```

- [ ] **Step 4: Create the secrets.** `secrets/worker.yaml` carries the user password the always-on module expects (`system/users/arrayofone/password`); `secrets/k3s-cluster.yaml` carries the token:

```bash
printf 'system:\n  users:\n    arrayofone:\n      password: %s\n' "$(mkpasswd -m sha-512)" \
  | sops --encrypt --input-type yaml --output-type yaml /dev/stdin > secrets/worker.yaml
printf 'k3s:\n  token: %s\n' "$(head -c32 /dev/urandom | base64)" \
  | sops --encrypt --input-type yaml --output-type yaml /dev/stdin > secrets/k3s-cluster.yaml
```

Wire the token in the worker host: add `sops.secrets."k3s/token".sopsFile = ../../../secrets/k3s-cluster.yaml;` and `fellowship.worker.k3s.tokenFile = config.sops.secrets."k3s/token".path;`.

- [ ] **Step 5 (hardware bootstrap):**
  1. Format the `K3S_STATE` device (ext4, label `K3S_STATE`); create `ssh/`, `sops-nix/`, `rancher/` subdirs; copy the pre-seeded `ssh_host_ed25519_key`(+`.pub`) into `ssh/`. For `local` bootstrap also create a `WORKER_ROOT` ext4 partition.
  2. **Gate check first** (`[fix: re#B7]`): `test -e /proc/sys/fs/binfmt_misc/aarch64-linux || { echo "Phase-1 baradur switch not done — binfmt inactive"; exit 1; }`. Then build: `nixos-rebuild build --flake .#worker` (**emulated; may take 30–90+ min** `[fix: H8]`), write it to the SD/`WORKER_ROOT`.
  3. Boot the Pi (`local`). Activation finds the pre-seeded key under `/etc/ssh` (bound from `/state/ssh`) → sops decrypts `secrets/worker.yaml` + the token → users + k3s come up.

Run (on the Pi): `sudo k3s kubectl get nodes`
Expected: one node `Ready`, roles `control-plane,master`.

- [ ] **Step 6: Commit.** `git add systems/aarch64-linux/worker .sops.yaml secrets/worker.yaml secrets/k3s-cluster.yaml && git commit -m "feat(worker) pi4 hardware config and pre-seeded sops identity"`

### Task 8b: Fetch + rewrite kubeconfig to baradur `[fix: C12]`

**Files:** Modify `Taskfile.yml`.

- [ ] **Step 1: Add a `kubeconfig:fetch` task** (operator runs once the server is up):

```yaml
  kubeconfig:fetch:
    desc: Pull k3s kubeconfig from the worker and point it at the VLAN IP
    vars: { IP: '{{.IP}}' }   # worker VLAN IP
    cmds:
      - mkdir -p ~/.kube
      - ssh arrayofone@{{.IP}} sudo cat /etc/rancher/k3s/k3s.yaml | sed 's#https://127.0.0.1:6443#https://{{.IP}}:6443#' > ~/.kube/worker.yaml   # [fix: re#B2]
      - echo "export KUBECONFIG=~/.kube/worker.yaml"
```

- [ ] **Step 2: Verify from baradur.** `KUBECONFIG=~/.kube/worker.yaml kubectl get nodes` → node Ready. (baradur has the VLAN sub-iface, so 6443 is routable.)
- [ ] **Step 3: Commit.** `git add Taskfile.yml && git commit -m "feat(netboot) fetch and rewrite worker kubeconfig"`

---

## Phase 3 — `nfs` root mode (prove the netboot chain)

### Task 9: Netboot with a live NFS root + the parameterized deploy task `[fix: C1/C2/C7]`

**Files:** Modify `systems/aarch64-linux/worker/default.nix` (`root.mode`); modify `Taskfile.yml`.

- [ ] **Step 1: Add `netboot:host`** populating the **complete** firmware tree (from `raspberrypifw` via the flake) + kernel + initrd, using the **real** build attrs `[fix: C1/C7]`:

```yaml
  netboot:host:
    desc: Build a worker's netboot artifacts and atomically publish to TFTP
    # MODE = nfs | ram. The host must set boot.loader.raspberry-pi.bootloader = "kernel".  [fix: re#F5]
    vars: { HOST: '{{.HOST}}', MAC: '{{.MAC}}', MODE: '{{.MODE}}' }
    cmds:
      - |
        set -euo pipefail
        C=".#nixosConfigurations.{{.HOST}}.config"
        DST=/srv/netboot/{{.MAC}}            # matches tftp-unique-root=mac (lowercase, colon-sep)
        GEN="$DST/$(date +%s)"; mkdir -p "$GEN"

        # kernel (REAL attr); initrd differs by mode: ram = netbootRamdisk (store baked in).  [fix: re#F1/F2]
        KERNEL=$(nix build --no-link --print-out-paths "$C.system.build.kernel")
        if [ "{{.MODE}}" = "ram" ]; then
          INITRD=$(nix build --no-link --print-out-paths "$C.system.build.netbootRamdisk")
        else
          INITRD=$(nix build --no-link --print-out-paths "$C.system.build.initialRamdisk")
        fi
        install -Dm644 "$KERNEL/Image"  "$GEN/Image"
        install -Dm644 "$INITRD/initrd" "$GEN/initrd"

        # firmware blobs (start4.elf, fixup4.dat, *.dtb, overlays/) — NO `|| true`, fail loudly.  [fix: re#B1]
        FW=$(nix build --no-link --print-out-paths "$C.boot.loader.raspberry-pi.firmwarePackage")
        cp -r "$FW"/share/raspberrypi/boot/* "$GEN/"

        # config.txt — raspberrypifw does NOT ship it; generate it.  [fix: re#F5]
        # The flake exposes it via configTxtPackage (a derivation with a config.txt). Verify the
        # exact attr on first run: `nix eval --json $C.boot.loader.raspberry-pi --apply builtins.attrNames`.
        CFG=$(nix build --no-link --print-out-paths "$C.boot.loader.raspberry-pi.configTxtPackage")
        cp "$CFG/config.txt" "$GEN/config.txt"
        # ensure config.txt names the kernel we installed ("Image") + the initrd:
        grep -q '^kernel=Image' "$GEN/config.txt" || echo "kernel=Image"            >> "$GEN/config.txt"
        grep -q '^initramfs initrd' "$GEN/config.txt" || echo "initramfs initrd followkernel" >> "$GEN/config.txt"

        # cmdline.txt — DRY: derive from the host's own kernelParams (set by root.nix nfs branch).  [fix: re#F4]
        nix eval --raw "$C.boot.kernelParams" --apply 'ps: builtins.concatStringsSep " " ps' \
          | sed 's/$/ console=tty1 console=serial0,115200/' > "$GEN/cmdline.txt"

        # HARD ASSERT a bootable set before publishing — never flip `current` to a broken tree.  [fix: re#B1]
        for f in start4.elf fixup4.dat config.txt cmdline.txt Image initrd; do
          test -s "$GEN/$f" || { echo "MISSING $f — refusing to publish"; exit 1; }
        done

        ln -sfn "$GEN" "$DST/current"        # atomic publish
        ls -dt "$DST"/[0-9]* | tail -n +4 | xargs -r rm -rf   # keep last 3 generations  [fix: re#B6]
```

> **HARDWARE-VALIDATE `[fix: C2/re#F5]`:** `bootloader = "kernel"` (Step 2) makes the flake generate a `config.txt` with `kernel=…` instead of chainloading u-boot; the Taskfile copies it and asserts `kernel=Image`/`initramfs initrd`. Confirm the **exact `configTxtPackage` attr name** (`nix eval --json $C.boot.loader.raspberry-pi --apply builtins.attrNames`) and that the kernel filename in the generated `config.txt` matches the installed `Image`. Validate against the Pi's HDMI/serial console; `nfs` is the proven rung before `ram`.

- [ ] **Step 2: Flip to nfs mode + the netboot bootloader** in the worker host:

```nix
    root = { mode = "nfs"; target = "10.0.30.2:/mnt/node/netboot-roots/worker"; };
    # netboot loads the kernel directly (not u-boot/extlinux):  [fix: re#F5]
    boot.loader.raspberry-pi.bootloader = "kernel";
```

> **HARDWARE-VALIDATE:** the kernel `nfsroot` export must be a **materialized NixOS root directory** (a real `/` tree), not just a store copy. Materializing it from `config.system.build.toplevel` into `rootStore/worker/` (e.g. via `pkgs.runCommand` that lays out `/nix/store` + the system profile symlinks) is part of `netboot:host MODE=nfs` and is the #1 thing to get working on hardware. v3+`nolock` is the documented-working RPi path.

- [ ] **Step 3: Set Pi 4 EEPROM** (one-time, while SD-booted): `sudo rpi-eeprom-config --edit` → `BOOT_ORDER=0xf21`, `TFTP_PREFIX=1` (MAC subdir) `[fix: H6]`.
- [ ] **Step 4 (hardware):** `task netboot:host HOST=worker MODE=nfs MAC=<lowercase:colon:mac>` on baradur; power-cycle the Pi (SD still inserted as `0xf21` fallback).

Run (Pi): `findmnt / && KUBECONFIG=~/.kube/worker.yaml kubectl get nodes` (from baradur)
Expected: `/` is `nfs4`; node Ready.

- [ ] **Step 5: Commit.** `git add systems/aarch64-linux/worker/default.nix Taskfile.yml && git commit -m "feat(worker) netboot via live nfs root"`

---

## Phase 4 — `ram` root mode (resilient default)

### Task 10: TFTP-loaded RAM root via upstream `netbootRamdisk` `[fix: re#F1/F2]`

**Files:** Modify `flake.nix` (host import); modify `systems/aarch64-linux/worker/default.nix`; modify `Taskfile.yml` (already MODE-aware from Task 9).

> **MECHANISM (corrected by re-review):** my v2 "NFS-pull a whole-root squashfs + overlay" design was invalid — busybox stage-1 has no `mount.nfs`, and NixOS RAM-boot doesn't work that way. The supported mechanism is upstream `installer/netboot/netboot.nix`: it sets `fileSystems."/"` = tmpfs, bundles the **store** squashfs *inside* the initrd (`netbootRamdisk`), and mounts it at `/nix/.ro-store`. We TFTP-load that kernel+initrd. The OS is then **entirely in RAM** — no runtime NFS at all, so it's *more* resilient to a baradur reboot than the v2 design. The `ram` branch in `root.nix` (Task 7) already reduced to just the NIC module; netboot.nix owns the root.

- [ ] **Step 1: Import the netboot profile for the ram host** (imports can't be gated on `root.mode`, so this is host-level). In `flake.nix` `systems.hosts`:

```nix
worker.modules = with inputs; [
  nixos-raspberrypi.nixosModules.raspberry-pi-4.base
  "${nixpkgs}/nixos/modules/installer/netboot/netboot.nix"   # provides netbootRamdisk + squashfsStore
];
```

- [ ] **Step 2: Flip to ram mode + netboot bootloader:**

```nix
    root = { mode = "ram"; target = ""; };   # target unused in ram (root is in the initrd)
    boot.loader.raspberry-pi.bootloader = "kernel";
```

- [ ] **Step 3: Build + publish** — `netboot:host MODE=ram` (Task 9) already builds `config.system.build.netbootRamdisk` (store squashfs baked in) + `kernel` and asserts the firmware/config.txt set. No separate `root.squashfs`, no `pkgs.makeSquashfs`.

Run (baradur): `task netboot:host HOST=worker MODE=ram MAC=<lowercase:colon:mac>`

- [ ] **Step 4 (hardware): boot + resilience test.**

Run (Pi): `findmnt / && findmnt /nix/.ro-store && free -h` → `/` is `tmpfs`, `/nix/.ro-store` is the squashfs.
Then **reboot baradur**; confirm `KUBECONFIG=~/.kube/worker.yaml kubectl get nodes` still shows the worker Ready while baradur is down (RAM root + local k3s state survive — baradur only needed for *new* boots). `[fix: spec resilience claim]`

- [ ] **Step 5: Commit.** `git add flake.nix systems/aarch64-linux/worker/default.nix Taskfile.yml && git commit -m "feat(worker) tftp-loaded ram root via upstream netbootRamdisk"`

---

## Phase 5 — Pi 5 `agent` joins

### Task 11: Migrate `agent` onto the worker profile `[fix: F9/G2]`

**Files:** Modify `flake.nix`, `systems/aarch64-linux/agent/default.nix`, `modules/nixos/netboot/default.nix`, `.sops.yaml`, create `secrets/agent.yaml`.

- [ ] **Step 1: Inject the Pi 5 module** (replaces the impure `fetchTarball` kernel): `agent.modules = with inputs; [ nixos-raspberrypi.nixosModules.raspberry-pi-5.base ];`
- [ ] **Step 2: Rewrite `agent/default.nix`** with `board = "pi5"` (→ `macb` NIC, `bcm2712-rpi-5-b.dtb`):

```nix
{ config, ... }:
{
  fellowship.worker = {
    enable = true; board = "pi5"; bootServer = "10.0.30.2";
    root = { mode = "ram"; target = "10.0.30.2:/mnt/node/netboot-roots/agent";
             extraConfig.export = "/mnt/node/netboot-roots/agent"; };
    k3s = { role = "agent"; target = "https://10.0.30.5:6443";   # worker's reserved VLAN IP
            tokenFile = config.sops.secrets."k3s/token".path; stateDevice = "/dev/disk/by-label/K3S_STATE"; };
  };
  sops.secrets."k3s/token".sopsFile = ../../../secrets/k3s-cluster.yaml;
  networking.hostName = "agent";
}
```

- [ ] **Step 3: Pre-seed agent identity** (Task 8 Step 2–5 process for `agent`), add `&agent` to `.sops.yaml`, and add it to the `k3s-cluster.yaml` key group so both hosts decrypt the **same** token `[fix: G2]`.
- [ ] **Step 4: Register the netboot client:** `clients.agent = { serial = "<pi5-serial>"; mac = "<pi5-mac>"; address = "10.0.30.6"; };`
- [ ] **Step 5 (hardware):** `task netboot:host HOST=agent MAC=<mac> SERIAL=<serial>` (Pi 5 EEPROM: confirm netboot-capable firmware + BOOT_ORDER). Boot.

Run (baradur): `KUBECONFIG=~/.kube/worker.yaml kubectl get nodes -o wide`
Expected: two Ready nodes — `worker` (control-plane) + `agent` (worker).

- [ ] **Step 6: Commit.** `git add flake.nix systems/aarch64-linux/agent .sops.yaml secrets/agent.yaml modules/nixos/netboot/default.nix && git commit -m "feat(agent) join pi5 to the k3s cluster via the worker profile"`

---

## Phase 6 — Optional hardening

### Task 12: NFS StorageClass for PVCs + etcd snapshots `[fix: G1]`

- [ ] **Step 1:** Deploy `csi-driver-nfs` via a k3s auto-deploy manifest written by the worker module to `/var/lib/rancher/k3s/server/manifests/nfs-csi.yaml`, with a `StorageClass nfs` pointing at `bootServer:pvcExport`. (This is the spec's "in-cluster NFS provisioner client" — implemented here, not hand-waved.)
- [ ] **Step 2:** `systemd.timer` running `k3s etcd-snapshot save` → `bootServer:pvcExport/etcd-snapshots` (insurance for `K3S_STATE` loss `[fix: H6/secrets]`). Works because the server runs embedded etcd (`--cluster-init`, Task 6) — a default sqlite server has nothing to snapshot `[fix: re#3]`.
- [ ] **Step 3 (verify):** `kubectl apply` a 1Gi PVC on StorageClass `nfs` → `Bound`; confirm a snapshot file on baradur.
- [ ] **Step 4: Commit.** `git commit -m "feat(worker) nfs storageclass and etcd snapshots"`

### Task 13: Register the live Pi as a native aarch64 remote builder `[fix: H8]`

- [ ] **Step 1:** `nix.buildMachines = [{ hostName = "worker"; sshUser = "..."; system = "aarch64-linux"; maxJobs = 4; }]; nix.distributedBuilds = true;` + SSH key on baradur. Cuts the multi-hour emulated builds to native.
- [ ] **Step 2 (verify):** `nix build --rebuild .#nixosConfigurations.worker.config.system.build.toplevel --print-build-logs` offloads to the Pi; compare wall-clock vs emulation.
- [ ] **Step 3: Commit.** `git commit -m "feat(baradur) use live pi as native aarch64 remote builder"`

---

## Self-Review (completed during authoring)

- **Review-finding coverage:** every Critical/High from the 5-agent review maps to a `[fix: …]` tag — C1 (firmware tree, T9), C2 (bootloader-per-mode, T9), C3 (dnsmasq pxe reply, T4), C4/F5/F6 (ip=dhcp + NIC modules + scripted copytoram, T7/T10), C5 (k3s mkMerge, T6), C6 (single state device, T6), C7 (real build attrs, T9), C8 (single firewall/tmpfiles assignment, T4), C9/H5 (pre-seeded identity, T8), C10 (per-mode deploy loop), C11 (scripted VLAN, T3), C12 (kubeconfig fetch, T8b), H1/H3/E4 (NFS squash/NFSv4/no trustedInterfaces, T5), H2 (no 0644 kubeconfig, T6), H4/B4 (no fileSystems dup, T8), H6 (BOOT_ORDER 0xf21 + versioned `current`), H7 (Pi access port, T5), H8 (build-time caveat + T13), B5 (mkDefault, T6), B6 (no root-fs conflict — base declares none), G1 (NFS provisioner is a real task, T12), G2 (shared token key group, T8/T11), G6/R6 (no-NAT assertion, T3), F9 (board-parameterized NIC/DTB, T6/T11).
- **Verified facts in use:** module path `raspberry-pi-{4,5}.base`; scripted stage-1; `config.system.build.{kernel,initialRamdisk,netbootRamdisk}` (kernelFile `Image`); firmware via `raspberrypifw`; NIC `bcmgenet`/`macb`; `ip=dhcp` required; upstream `netboot.nix` provides `netbootRamdisk`.
- **Residual MUST-VERIFY (execution-time, the hardware-bring-up frontier):** exact `configTxtPackage` attr name + that generated `config.txt` names `Image` (T9); the **materialized NFS root export** for `nfs` mode + v3-vs-v4.1 on the RPi initrd (T9); kernel `root=/dev/nfs` vs NixOS `fileSystems."/"` interplay (T7); `tftp-unique-root`↔`TFTP_PREFIX` + MAC casing (T4); `bcmgenet`/`macb` built-in vs module (T7); `netbootRamdisk` boots on RPi over TFTP (T10); Pi 5 EEPROM netboot capability (T11).

## Open risks carried into execution

- **The boot chain is still the highest-risk axis.** The `local → nfs → ram` ladder is the de-risking path; do not skip rungs. `ram` (T10) is the most novel and may fall back to the upstream-netboot import.
- Emulated aarch64 builds are slow (T13 mitigates). `K3S_STATE` durability relies on etcd snapshots (T12). The Pi's identity at rest on a removable device is a documented physical-theft residual.
