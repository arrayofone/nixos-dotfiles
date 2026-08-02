# Pi Netboot Worker — Operator Runbook

Operator-facing procedures the implementation plan defers to. Hardware steps require the
actual Pi(s) + UniFi access. Companion to `2026-06-21-pi-netboot-k3s-worker.md`.

## Status

- **Done (software infra):** `nixos-raspberrypi` flake input; `fellowship.netboot` module
  (proxy-DHCP + TFTP + NFSv4 + scripted VLAN + binfmt + arch-aware/EFI clients); `fellowship.worker`
  module (k3s, `/state` device + binds, `root.mode` ram/nfs/local, NFS StorageClass + etcd
  snapshots). `fellowship.netboot` is **enabled on baradur** (`enp42s0` / VLAN 30, settled
  addresses below). The `worker` (Pi 4) and `agent` (Pi 5) hosts exist in-repo, bootstrap-ladder
  rung `local`, `fellowship.worker.enable = true`. The `netboot:*`/`kubeconfig:fetch` Taskfile
  targets exist.
  **Kernel verdict:** RED — `nixos-raspberrypi`'s vendor modules (`raspberry-pi-4.base` /
  `raspberry-pi-5.base`) don't evaluate under this flake's Snowfall-driven `specialArgs`
  (they require a `nixos-raspberrypi` special arg bound to the vendor flake's own `self`,
  which Snowfall Lib's system builder never provides). Both hosts run the mainline kernel
  (`boot.loader.generic-extlinux-compatible`) — see the `worker` host's commit body for the
  exact eval error, should a future retest be worth another look.
- **Deferred (needs the Pi + UniFi, this doc):** pre-seed sops identity per host; UniFi VLAN
  + firewall; flash + EEPROM; first boot; kubeconfig fetch; all hardware bring-up below.

## Settled values

| Item | Value |
| --- | --- |
| VLAN | 30, on `enp42s0` (iface `enp42s0.30`) |
| baradur (netboot server) | `10.0.30.2/24` |
| worker — Pi 4, k3s server | `10.0.30.11` |
| agent — Pi 5, k3s agent | `10.0.30.12` |
| `rootStore` (NFS root export, `nfs` mode) | `/mnt/node/netboot-roots` |
| `pvcExport` (NFS PVC + etcd-snapshot export) | `/mnt/node/k8s-pvcs` |

## Bootstrap ladder (`root.mode`)

Each host file (`systems/aarch64-linux/{worker,agent}/default.nix`) has a single
`let rootMode = "local";` binding, marked `# BOOTSTRAP LADDER`. Advance one rung at a time —
edit `rootMode`, redeploy per that rung, verify on hardware, **then** commit the flip. Never
skip a rung (don't jump straight to `ram` without proving `nfs`, or `nfs` without proving
`local`).

1. **`local`** — Pi boots off its own on-disk root (`NIXOS_SD` label). Normal on-disk install.
2. **`nfs`** — kernel-driven NFS root (busybox stage-1 has no `mount.nfs`), served from
   baradur's `rootStore`. Proves the netboot chain end-to-end.
3. **`ram`** — TFTP-loaded RAM root (`netbootRamdisk`; the Nix store squashfs is baked into
   the initrd, no runtime NFS). The resilient default: once booted, a baradur reboot can't
   touch a running node.

Deploy command per rung — see "Per-mode deploy loop" below; never `nixos-rebuild switch` **on**
a Pi once it's off `local`.

## The binfmt gate

Nothing aarch64 builds on baradur — not `worker`/`agent` toplevel, not sdImages, not netboot
artifacts — until **baradur's own first `switch`** activates `fellowship.netboot`'s binfmt
registration (`/proc/sys/fs/binfmt_misc/qemu-aarch64` is empty until then). Of the `netboot:*`
targets, `task netboot:host` and `task netboot:sdimage` check that path first and exit 1 if
it's missing (both build aarch64 closures); `task netboot:seed` needs no gate — it only
generates a host key + age identity, no aarch64 build involved. So the first hardware step,
always, is switching baradur (UniFi step 5 / bootstrap step 1 below) — everything aarch64
depends on it transitively.

## UniFi / switch (Phase 1)

1. Create a VLAN-only network "worker", **VLAN id 30** (`fellowship.netboot.vlan`); DHCP **on**,
   **Network-Boot OFF** (else two boot responders collide with baradur's proxy-DHCP).
2. Reserve a static lease per Pi: worker (Pi 4) → **10.0.30.11**, agent (Pi 5) → **10.0.30.12**
   (already set as `fellowship.netboot.clients.<host>.address` on baradur; only the `mac`
   fields are blank in-repo — filled in from dnsmasq's logs at each Pi's first PXE attempt,
   then committed).
3. Tag baradur's switch port for the worker VLAN (trusted VLAN stays untagged).
4. Set each **Pi's** switch port to **untagged / access = worker VLAN** (the Pi boot ROM
   emits untagged frames).
5. UniFi firewall: allow worker→baradur TCP 2049 + UDP 67/69/4011; worker→WAN for image pulls.
6. `sudo nixos-rebuild switch --flake .#baradur` (or `task switch:nixos`) — activates dnsmasq
   proxy-DHCP/TFTP, the NFSv4 exports, the VLAN sub-interface, and the binfmt gate above.
   Verify: `systemctl is-active dnsmasq nfs-server` → `active`; `ip -br addr show enp42s0.30`
   shows `10.0.30.2/24`; `exportfs -v` lists both exports.

## Bootstrap order (first boot, per host)

Run once per Pi (`<host>` = `worker` or `agent`), after UniFi step 6 above:

1. `task netboot:seed HOST=<host>` — generates `/tmp/<host>-seed/ssh_host_ed25519_key`(`.pub`)
   and prints the host's derived age public key.
2. Replace the `PLACEHOLDER_AGE_PUBLIC_KEY` for `&<host>` in `.sops.yaml` with the key from
   step 1.
3. `sops updatekeys secrets/k3s-cluster.yaml` — adds `<host>` to the shared token's recipient
   set (the `.sops.yaml` rule carries a `# bootstrap: add *worker, *agent …` comment marking
   this step; `nix shell nixpkgs#sops -c sops updatekeys …` if `sops` isn't on PATH).
4. Create `secrets/<host>.yaml`, carrying the user password the always-on module expects
   (June plan Task 8 Step 4; run from the repo root so `.sops.yaml`'s new rule applies):
   ```bash
   printf 'system:\n  users:\n    arrayofone:\n      password: %s\n' "$(mkpasswd -m sha-512)" \
     | sops --encrypt --input-type yaml --output-type yaml /dev/stdin > secrets/<host>.yaml
   ```
   (`secrets/k3s-cluster.yaml` — the shared k3s token — already exists; step 3 above just adds
   `<host>` as a recipient.)
5. Format the `K3S_STATE` device (ext4, label `K3S_STATE`); create `ssh/`, `sops-nix/`,
   `rancher/` subdirs; copy step 1's key pair into `ssh/` — this pre-seeds the identity so the
   Pi's **first** activation can decrypt its secrets (no bootstrap circularity). For a first
   `local`-rung boot, also format a `NIXOS_SD`-labelled root partition.
6. `task netboot:sdimage HOST=<host>` — builds the sdImage artifact (binfmt-gated) and echoes
   the flash hint.
7. Flash: `sudo dd if=<sdImage>/sd-image/*.img of=/dev/sdX bs=4M status=progress conv=fsync`.
   Insert into the Pi and boot.
8. EEPROM (one-time, while SD-booted):
   ```bash
   sudo rpi-eeprom-config --edit   # BOOT_ORDER=0xf21 (SD then network), TFTP_PREFIX=1 (no client-side prefix; dnsmasq adds the per-MAC subdir server-side)
   ```
   **Pi 5 (`agent`) only:** confirm the bootloader EEPROM is netboot-capable before relying on
   the `nfs`/`ram` rungs — `sudo rpi-eeprom-update -a` reports current vs. latest; run
   `sudo rpi-eeprom-update -d -a` to apply an update if the network boot order digit isn't
   accepted (early Pi 5 EEPROM revisions predate netboot support).
9. On the Pi: `sudo k3s kubectl get nodes` → one `Ready` node.
10. From baradur: `task kubeconfig:fetch IP=<pi-vlan-ip>` (worker → `10.0.30.11`), then
    `export KUBECONFIG=~/.kube/worker.yaml && kubectl get nodes`.

## Per-mode deploy loop

- **local** — build + `nixos-rebuild switch --flake .#<host>` ON the Pi (normal on-disk).
- **nfs / ram** — apply changes on **baradur**: `task netboot:host HOST=<host> MODE=<nfs|ram>
  MAC=<lowercase-dash-mac>` rebuilds the closure, repopulates `/srv/netboot/<mac>/<gen>/`,
  flips the `current` symlink, then **power-cycle the Pi**. Never `switch` on the Pi.
  `MAC` is dnsmasq's `tftp-unique-root=mac` form — lowercase, dash-separated
  (e.g. `dc-a6-32-01-02-03`), not colon-separated.

## Brick recovery

A bad netboot image: pull power → the Pi falls back to the SD (`BOOT_ORDER=0xf21`), or flip
`/srv/netboot/<mac>/current` back to the previous generation and power-cycle. Keep a
known-good `local` SD inserted.

## kubeconfig (drive the cluster from baradur)

```bash
task kubeconfig:fetch IP=<worker-vlan-ip>   # worker: 10.0.30.11
export KUBECONFIG=~/.kube/worker.yaml && kubectl get nodes
```

Equivalent by hand, if the task target is unavailable:

```bash
ssh arrayofone@<worker-ip> sudo cat /etc/rancher/k3s/k3s.yaml \
  | sed 's#https://127.0.0.1:6443#https://<worker-ip>:6443#' > ~/.kube/worker.yaml
```

## x86_64 worker (future)

`fellowship.netboot.clients` already carries an `arch` option (`"rpi"` default,
`"x86_64-efi"` for a UEFI PXE client) — baradur's dnsmasq proxy-DHCP/`pxe-service` answers
the EFI64 `client-arch` tags (7/9) and per-EFI-client `systemd.tmpfiles` rules already
symlink `ipxe.efi` + a chainloading `netboot.ipxe` into `<tftpRoot>/<mac>/` for any client
with `arch = "x86_64-efi"`. The one piece deliberately **not** provided: `config.ipxe` itself
— a future x86_64 artifact-pipeline target owns generating and publishing it, the same
"artifact pipeline owns it" contract the Pis' `current` symlink follows. That whole EFI path
is marked `# ON-HARDWARE-TUNABLE` in `modules/nixos/netboot/default.nix` — proxy-DHCP + UEFI
PXE is firmware-sensitive and untested until an actual x86_64 box shows up.

## Known hardware-validation items (the netboot frontier)

- The materialized NFS **root export** for `nfs` mode (a real `/` tree, not a store copy).
- `vers=3` vs `vers=4.1` over the kernel `nfsroot` on the RPi initrd.
- Exact `configTxtPackage` attr name; generated `config.txt` must name `Image`. (The Taskfile's
  `netboot:host` falls back to `nixpkgs#raspberrypifw` + a hand-written `config.txt` today,
  since the kernel verdict above is RED and the vendor `firmwarePackage`/`configTxtPackage`
  attrs never evaluate.)
- `netbootRamdisk` boots over the Pi firmware's TFTP for `ram` mode.
- `bcmgenet`/`macb` built-in vs module; Pi 5 EEPROM netboot capability (bootstrap step 8 above).
- NFS pseudo-root vs. absolute export path for the `nfs.csi.k8s.io` StorageClass `share` and
  the etcd-snapshot NFS mount (both currently `/k8s-pvcs`, marked `ON-HARDWARE-VALIDATE` in
  `modules/nixos/worker/default.nix`).
- Proxy-DHCP + UEFI PXE handshake for the x86_64-EFI client path (see above) — untested,
  firmware-sensitive.
