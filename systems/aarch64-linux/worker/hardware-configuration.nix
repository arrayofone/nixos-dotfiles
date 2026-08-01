# June plan Task 8 Step 1 verbatim. Written for the vendor `raspberry-pi-4.base`
# module (kernel + raspberrypifw firmware + bootloader); the 2026-08-01 retest
# (see the worker host's commit body) fell back to the mainline kernel instead
# — boot.loader is set in ./default.nix. Kept minimal either way: no
# fileSystems here, those are owned by the worker module (Task 6/7).
{ lib, ... }:
{
  networking.useDHCP = lib.mkDefault true;
}
