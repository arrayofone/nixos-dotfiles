# uni-sync — boot-time fan configuration for Lian Li Uni fan hubs.
#
# Pinned to tymscar's fork (upstream PR: https://github.com/EightB1ts/uni-sync/pull/32)
# because the UNI FAN SL v1.2 hub (0cf2:a100) ignores HID writes entirely — its firmware
# only speaks a vendor control-transfer protocol (setup channel -> RPM LE16 -> commit),
# which neither upstream uni-sync nor liquidctl implement yet
# (https://github.com/liquidctl/liquidctl/issues/858). Drop this fork and use
# upstream/nixpkgs once PR #32 (or liquidctl support) lands.
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  udev,
}:
rustPlatform.buildRustPackage {
  pname = "uni-sync";
  version = "0.3.1-pr32-sl-v1.2";

  src = fetchFromGitHub {
    owner = "tymscar";
    repo = "uni-sync";
    rev = "ea0a35840dbdace39e8881aa850e304b4abc8dcb";
    hash = "sha256-psA/e1u6i2snB/eaYSmC3hsKjFYUgs+EarGX3bhhw1M=";
  };

  cargoHash = "sha256-pprX8/d3x5u4ZegkAwBZ7fhf1IDFEcKHH/RuS5pXyBE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libusb1
    udev
  ];

  meta = {
    description = "Lian Li Uni fan hub speed tool (fork with SL v1.2 vendor-transfer support)";
    mainProgram = "uni-sync";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
