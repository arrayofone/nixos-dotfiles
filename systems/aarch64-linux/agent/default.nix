{ config, lib, modulesPath, ... }:
let
  # BOOTSTRAP LADDER — flip "local" -> "nfs" -> "ram" per the runbook, one rung per commit.
  rootMode = "local";
in
{
  imports =
    lib.optional (rootMode == "local") "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ++ lib.optional (rootMode == "ram") "${modulesPath}/installer/netboot/netboot.nix";

  # RETEST VERDICT (2026-08-01, mirrored from the worker/pi4 host — see its commit body
  # for the exact eval error): nixos-raspberrypi's `raspberry-pi-5.base` module carries the
  # same Snowfall specialArgs incompatibility as `raspberry-pi-4.base` (requires a
  # `nixos-raspberrypi` special arg bound to its own flake `self`, which Snowfall Lib's
  # system builder does not provide). Mainline kernel stands, same as before this migration
  # — the worker profile is kernel-agnostic, so no flake.nix injection is added.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fellowship.worker = {
    enable = true;
    board = "pi5";
    bootServer = "10.0.30.2";
    root = {
      mode = rootMode;
      target = if rootMode == "local" then "/dev/disk/by-label/NIXOS_SD"
               else "10.0.30.2:/mnt/node/netboot-roots/agent";
    };
    k3s = {
      role = "agent";
      target = "https://10.0.30.11:6443";
      tokenFile = config.sops.secrets."k3s/token".path;
      stateDevice = "/dev/disk/by-label/K3S_STATE";
    };
  };
  sops.secrets."k3s/token".sopsFile = ../../../secrets/k3s-cluster.yaml;
  # modules/nixos/worker's bind mounts (/etc/ssh, /var/lib/sops-nix,
  # /var/lib/rancher/k3s — PR #5, out of this task's file scope) predate current
  # nixpkgs requiring fileSystems.<name>.fsType explicitly (no more "auto"
  # default); host-level override, standard bind-mount idiom (same fix as worker).
  fileSystems."/etc/ssh".fsType = "none";
  fileSystems."/var/lib/sops-nix".fsType = "none";
  fileSystems."/var/lib/rancher/k3s".fsType = "none";

  networking.hostName = "agent";
  system.stateVersion = "24.05";
}
