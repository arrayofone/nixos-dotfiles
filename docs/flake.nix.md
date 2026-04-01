---
title: Flake Configuration
tags: [flake, inputs, snowfall]
---

# Flake Configuration

> [!tip] Gitian Annotations
> The source file contains `@gitian:input` and `@gitian:host` annotations
> that document each input group and host configuration inline.

## Input Groups

The flake inputs fall into three categories:

### Core (all platforms)
| Input | Purpose |
|-------|---------|
| `nixpkgs` | Package repository (unstable channel) |
| `snowfall-lib` | Module framework with auto-discovery |
| `home-manager` | User environment management |
| `sops-nix` | Encrypted secrets decryption at activation |
| `stylix` | Global base16 theming engine |

### NixOS-only
| Input | Purpose |
|-------|---------|
| `hyprland` | Wayland compositor (baradur desktop) |
| `microvm` | Firecracker VM framework (helms-deep) |
| `ethereum-nix` | Ethereum node packages (baradur) |

### Darwin-only
| Input | Purpose |
|-------|---------|
| `darwin` | nix-darwin system management |
| `nix-rosetta-builder` | x86_64 cross-compilation on Apple Silicon |
| `nix-homebrew` | Declarative Homebrew tap management |
| `homebrew-core/cask/bun` | Homebrew tap sources (non-flake) |

## Host Configuration

Each host gets per-host module injection via `systems.hosts.<name>.modules`:

- **baradur**: Ethereum node modules
- **helms-deep**: MicroVM host module
- **dbook/mingabook**: Rosetta builder + Homebrew modules
- **digibook**: Same as dbook (see `systems/aarch64-darwin/digibook/`)

> [!warning] Rosetta Builder Bootstrap
> `nix-rosetta-builder` requires an existing Linux builder for first setup.
> See the commented instructions in flake.nix for the bootstrap dance.

## Snowfall Library Integration

The `mkLib` call configures Snowfall with:
- `namespace = "fellowship"` — all module options live under `config.fellowship.*`
- `src = ./.` — auto-discovers everything under the repo root
- `allowUnfree = true` — permits proprietary packages (Steam, Slack, etc.)
