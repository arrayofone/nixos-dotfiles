# Pi Netboot Worker — Operator Runbook

Operator-facing procedures the implementation plan defers to. Hardware steps require the
actual Pi(s) + UniFi access. Companion to `2026-06-21-pi-netboot-k3s-worker.md`.

## Status

- **Done (software infra, this PR):** `nixos-raspberrypi` flake input; `fellowship.netboot`
  module (proxy-DHCP + TFTP + NFSv4 + scripted VLAN + binfmt); `fellowship.worker` module
  (k3s, `/state` device + binds, `root.mode` ram/nfs/local). Both modules ship **inert**
  (`enable = false`) — no host enables them yet.
- **Deferred (needs the Pi + UniFi):** instantiate the `worker` (Pi 4) and `agent` (Pi 5)
  hosts; pre-seed sops identity; enable `fellowship.netboot` on baradur; the netboot
  artifact `Taskfile` target; all hardware bring-up.

## UniFi / switch (Phase 1)

1. Create a VLAN-only network "worker" with id = `fellowship.netboot.vlan`; DHCP **on**,
   **Network-Boot OFF** (else two boot responders collide with baradur's proxy-DHCP).
2. Reserve a static lease per Pi → fills `fellowship.netboot.clients.<host>.address`.
3. Tag baradur's switch port for the worker VLAN (trusted VLAN stays untagged).
4. Set each **Pi's** switch port to **untagged / access = worker VLAN** (the Pi boot ROM
   emits untagged frames).
5. UniFi firewall: allow worker→baradur TCP 2049 + UDP 67/69/4011; worker→WAN for image pulls.

## Pre-seed sops identity (per host, before first boot)

```bash
ssh-keygen -t ed25519 -N "" -f /tmp/<host>-seed/ssh_host_ed25519_key
AGE=$(nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /tmp/<host>-seed/ssh_host_ed25519_key.pub')
# add $AGE to .sops.yaml as &<host>; encrypt secrets/<host>.yaml (password) +
# secrets/k3s-cluster.yaml (token, key group [worker, agent, arrayofone]); commit.
# Format K3S_STATE (ext4, label K3S_STATE) with ssh/ sops-nix/ rancher/ subdirs;
# copy the seed key into ssh/ so the FIRST activation can decrypt (no circularity).
```

## EEPROM (one-time, while SD-booted)

```bash
sudo rpi-eeprom-config --edit   # BOOT_ORDER=0xf21 (SD then network), TFTP_PREFIX=1 (MAC subdir)
```

## Per-mode deploy loop

- **local** — build + `nixos-rebuild switch --flake .#<host>` ON the Pi (normal on-disk).
- **nfs / ram** — apply changes on **baradur**: `task netboot:host HOST=<host> MODE=<nfs|ram>
  MAC=<lowercase:colon:mac>` rebuilds the closure, repopulates `/srv/netboot/<mac>/<gen>/`,
  flips the `current` symlink, then **power-cycle the Pi**. Never `switch` on the Pi.

## Brick recovery

A bad netboot image: pull power → the Pi falls back to the SD (`BOOT_ORDER=0xf21`), or flip
`/srv/netboot/<mac>/current` back to the previous generation and power-cycle. Keep a
known-good `local` SD inserted.

## kubeconfig (drive the cluster from baradur)

```bash
ssh arrayofone@<worker-ip> sudo cat /etc/rancher/k3s/k3s.yaml \
  | sed 's#https://127.0.0.1:6443#https://<worker-ip>:6443#' > ~/.kube/worker.yaml
export KUBECONFIG=~/.kube/worker.yaml && kubectl get nodes
```

## Known hardware-validation items (the netboot frontier)

- The materialized NFS **root export** for `nfs` mode (a real `/` tree, not a store copy).
- `vers=3` vs `vers=4.1` over the kernel `nfsroot` on the RPi initrd.
- Exact `configTxtPackage` attr name; generated `config.txt` must name `Image`.
- `netbootRamdisk` boots over the Pi firmware's TFTP for `ram` mode.
- `bcmgenet`/`macb` built-in vs module; Pi 5 EEPROM netboot capability.
