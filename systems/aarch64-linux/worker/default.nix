{ config, lib, modulesPath, ... }:
let
  # BOOTSTRAP LADDER — flip "local" -> "nfs" -> "ram" per the runbook, one rung per commit.
  rootMode = "local";
in
{
  imports =
    [ ./hardware-configuration.nix ]
    ++ lib.optional (rootMode == "local") "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ++ lib.optional (rootMode == "ram") "${modulesPath}/installer/netboot/netboot.nix";

  # RETEST VERDICT (2026-08-01): nixos-raspberrypi HEAD (67616c2) still fails to
  # evaluate under this flake's Snowfall-driven specialArgs contract — the vendor
  # `raspberry-pi-4.base` module requires a `nixos-raspberrypi` special arg bound
  # to its own flake self, which Snowfall Lib doesn't provide via a bare
  # `worker.modules = with inputs; [ ... ]` injection (exact error in the commit
  # body). Falling back to the mainline kernel, same as the existing `agent`
  # stub — the worker profile is kernel-agnostic.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fellowship.worker = {
    enable = true;
    board = "pi4";
    bootServer = "10.0.30.2";
    # No operator SSH key found in-repo (dbook/mingabook carry empty authorizedKeys lists too) —
    # left unset (default [ ]); fill in at bootstrap per the runbook.
    root = {
      mode = rootMode;
      target = if rootMode == "local" then "/dev/disk/by-label/NIXOS_SD"
               else "10.0.30.2:/mnt/node/netboot-roots/worker";
    };
    k3s = {
      role = "server";
      stateDevice = "/dev/disk/by-label/K3S_STATE";
      tokenFile = config.sops.secrets."k3s/token".path;
    };
  };
  sops.secrets."k3s/token".sopsFile = ../../../secrets/k3s-cluster.yaml;

  networking.hostName = "worker";
  system.stateVersion = "24.05";
}
