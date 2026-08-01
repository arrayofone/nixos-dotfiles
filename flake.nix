# @gitian "Fellowship" — NixOS & nix-darwin dotfiles managed via Snowfall Library.
# Defines all flake inputs, system configurations, and per-host module injection.
# See [[architecture]] for the full system map.
{
  inputs = {
    # @gitian:input Core inputs shared by all platforms
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # @gitian:input nixpkgs-master — bleeding-edge nixpkgs for opt-in packages ahead of unstable.
    # Deliberately NOT following nixpkgs; pinned in flake.lock and advanced via `nix flake update nixpkgs-master`.
    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # @gitian:input NixOS-only inputs — Hyprland desktop, microVMs, and Ethereum nodes
    hyprland.url = "github:hyprwm/Hyprland";

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ethereum-nix = {
      url = "github:nix-community/ethereum.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # @gitian:input nixos-raspberrypi — vendor firmware/kernel for the diskless Pi netboot workers.
    # Deliberately NOT following nixpkgs: it pins a tested nixpkgs/firmware pair. Injected per-host
    # (raspberry-pi-4.base / raspberry-pi-5.base) when the Pi worker/agent hosts are instantiated.
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";

    # @gitian:input Darwin-only inputs — nix-darwin, Rosetta builder, and Homebrew
    # ###### #
    # DARWIN #
    # ###### #

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bun = {
      url = "github:oven-sh/homebrew-bun";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;

        src = ./.;

        snowfall = {
          namespace = "fellowship";

          meta = {
            name = "fellowship";
            title = "arrayofone's dotfiles";
          };
        };
      };
    in
    lib.mkFlake {
      src = ./.;

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = import ./data/permitted-insecure-packages.nix;
      };

      # @gitian NixOS-wide module injection. Snowfall auto-imports every
      # modules/nixos/* into every NixOS host, and the geth/microvm modules
      # reference options declared by these upstream modules — so the option
      # declarations must exist on every host, not just the ones that enable
      # them. Importing is inert until a host flips the corresponding enables.
      systems.modules.nixos = with inputs; [
        ethereum-nix.nixosModules.default
        microvm.nixosModules.host
      ];

      # @gitian:host baradur — x86_64-linux desktop (Hyprland, Nvidia, Ollama, Steam).
      # Imports ethereum-nix for potential validator/node operation.
      systems.hosts.baradur.modules = with inputs; [
        (
          { pkgs, system, ... }:
          {
            environment.systemPackages = (
              with ethereum-nix.packages.x86_64-linux;
              [
                #teku
                #lighthouse
              ]
            );
          }
        )
      ];

      # @gitian:host worker — aarch64-linux RPi4, diskless k3s server. Retested
      # 2026-08-01 against nixos-raspberrypi HEAD (67616c2, 2026-08-01):
      # `raspberry-pi-4.base` still fails to evaluate on a bare `with inputs;`
      # module injection — the vendor module itself requires a `nixos-raspberrypi`
      # special arg bound to its own flake `self` (its own flake.nix wires
      # `specialArgs = inputs // { nixos-raspberrypi = self; }`), which Snowfall
      # Lib's system builder does not provide (it nests inputs under
      # `specialArgs.inputs`, not a flat `nixos-raspberrypi` arg). Mainline
      # kernel stands; see the worker host's commit body for the exact error.

      # @gitian:host agent — aarch64-linux RPi5, currently on the mainline
      # kernel (its unpinned third-party nix-rpi5 fetchTarball broke pure
      # evaluation and was removed). The vendor kernel/firmware comes back via
      # nixos-raspberrypi in the pi-netboot plan's Phase 5 — as of 2026-07-24
      # that input (rev 2bbb6ee) cannot be mixed into a host on current
      # nixos-unstable (vendor kernel lacks buildDTBs/target passthru; its
      # legacyPackages cross-evaluates badly against the newer module set).

      # @gitian:host dbook — aarch64-darwin minimal macOS config.
      # Bootstraps nix-rosetta-builder for x86_64 cross-compilation on Apple Silicon.
      systems.hosts.dbook.modules = with inputs; [
        #   # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
        #   # If one isn't already available: comment out the `nix-rosetta-builder` module below,
        #   # uncomment this `linux-builder` module, and run `darwin-rebuild switch`:
        # { nix.linux-builder.enable = true; }
        #   # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
        #   # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
        nix-rosetta-builder.darwinModules.default
        {
          nix-rosetta-builder.enable = true;
          # see available options in module.nix's `options.nix-rosetta-builder`
          nix-rosetta-builder.onDemand = true;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "db";

            # Optional: Declarative tap management
            taps = {
              "oven-sh/homebrew-bun" = homebrew-bun;
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];

      # @gitian:host mingabook — aarch64-darwin primary dev laptop.
      # Current active machine. See [[mingabook]] for host-specific config.
      systems.hosts.mingabook.modules = with inputs; [
        #   # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
        #   # If one isn't already available: comment out the `nix-rosetta-builder` module below,
        #   # uncomment this `linux-builder` module, and run `darwin-rebuild switch`:
        # { nix.linux-builder.enable = true; }
        #   # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
        #   # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
        nix-rosetta-builder.darwinModules.default
        {
          nix-rosetta-builder.enable = true;
          # see available options in module.nix's `options.nix-rosetta-builder`
          nix-rosetta-builder.onDemand = true;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "darrenbangsund";

            # Optional: Declarative tap management
            taps = {
              "oven-sh/homebrew-bun" = homebrew-bun;
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
    };
}
