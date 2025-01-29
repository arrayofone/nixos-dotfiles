{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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

    # headscale.url = "github:juanfont/headscale";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    catppuccin.url = "github:catppuccin/nix";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    ethereum-nix = {
      url = "github:nix-community/ethereum.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

      shells = {
        default = "digits";
      };

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      systems.hosts.baradur.modules = with inputs; [
        ethereum-nix.nixosModules.default
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

      systems.hosts.digibook.modules = with inputs; [
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
              # "oven-sh/bun" = homebrew-bun;
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
