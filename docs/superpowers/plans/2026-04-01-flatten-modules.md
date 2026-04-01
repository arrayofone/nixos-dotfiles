# Flatten Module Structure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Flatten all Snowfall modules to one level per type (darwin/home/nixos), eliminating intermediate grouping directories (core/, gui/, dev/modules/) so every module is independently discovered.

**Architecture:** Each concern becomes its own Snowfall module directory (`modules/<type>/<name>/default.nix`). Option paths simplify from deep nesting (`fellowship.gui.desktop.hyprland`) to flat (`fellowship.hyprland`). The monolithic `home/core/` aggregator is split into independent modules. System and home configs are updated to use the new option paths.

**Tech Stack:** Nix, Snowfall Library, nix-darwin, NixOS, home-manager

---

## File Mapping

### Darwin Modules (old → new)

| Old Path | New Path | Option Path Change |
|---|---|---|
| `modules/darwin/core/default.nix` | `modules/darwin/system/default.nix` | `${namespace}.system.name` (unchanged) |
| `modules/darwin/core/secrets.nix` | `modules/darwin/secrets/default.nix` | (no custom options) |
| `modules/darwin/core/dock.nix` | `modules/darwin/dock/default.nix` | `local.dock.*` (unchanged) |
| `modules/darwin/core/fonts.nix` | `modules/darwin/fonts/default.nix` | (no custom options) |
| `modules/darwin/networking/wg/default.nix` | `modules/darwin/wireguard/default.nix` | `networking.wireguard.server.*` → `wireguard.*` |

### Home Modules (old → new)

**From core/ (always-on, no enable):**

| Old Path | New Path |
|---|---|
| `modules/home/core/default.nix` | `modules/home/packages/default.nix` (just the package list + zed-server file) |
| `modules/home/core/env.nix` | `modules/home/env/default.nix` |
| `modules/home/core/fonts.nix` | `modules/home/fonts/default.nix` |
| `modules/home/core/git.nix` | `modules/home/git/default.nix` |
| `modules/home/core/secrets.nix` | `modules/home/secrets/default.nix` |
| `modules/home/core/shell.nix` | `modules/home/shell/default.nix` |
| `modules/home/core/ssh.nix` | `modules/home/ssh/default.nix` |
| `modules/home/core/theme.nix` | `modules/home/theme/default.nix` |
| `modules/home/core/tmux.nix` | `modules/home/tmux/default.nix` |
| `modules/home/core/vscode.nix` | `modules/home/vscode/default.nix` |
| `modules/home/core/zeditor.nix` | `modules/home/zed/default.nix` |

**From dev/ (has enable):**

| Old Path | New Path | Option Path Change |
|---|---|---|
| `modules/home/dev/default.nix` | `modules/home/dev/default.nix` | `home.dev.*` → `dev.*` |
| `modules/home/dev/modules/db/default.nix` | `modules/home/dev-db/default.nix` | `home.dev_modules.db.*` → `dev-db.*` |
| `modules/home/dev/modules/flutter/default.nix` | `modules/home/dev-flutter/default.nix` | `home.dev_modules.flutter.*` → `dev-flutter.*` |
| `modules/home/dev/modules/go/default.nix` | `modules/home/dev-go/default.nix` | `home.dev_modules.go.*` → `dev-go.*` |
| `modules/home/dev/modules/gql/default.nix` | `modules/home/dev-gql/default.nix` | `home.dev_modules.gql.*` → `dev-gql.*` |
| `modules/home/dev/modules/js/default.nix` | `modules/home/dev-js/default.nix` | `home.dev_modules.js.*` → `dev-js.*` |

**From gui/desktop/ (has enable):**

| Old Path | New Path | Option Path Change |
|---|---|---|
| `modules/home/gui/desktop/dunst/default.nix` | `modules/home/dunst/default.nix` | `gui.desktop.dunst.*` → `dunst.*` |
| `modules/home/gui/desktop/hypridle/default.nix` | `modules/home/hypridle/default.nix` | `gui.desktop.hypridle.*` → `hypridle.*` |
| `modules/home/gui/desktop/hyprland/default.nix` | `modules/home/hyprland/default.nix` | `gui.desktop.hyprland.*` → `hyprland.*` |
| `modules/home/gui/desktop/hyprlock/default.nix` | `modules/home/hyprlock/default.nix` | `gui.desktop.hyprlock.*` → `hyprlock.*` |
| `modules/home/gui/desktop/waybar/default.nix` | `modules/home/waybar/default.nix` | `gui.desktop.waybar.*` → `waybar.*` |

**From gui/programs/ (has enable):**

| Old Path | New Path | Option Path Change |
|---|---|---|
| `modules/home/gui/programs/brave/default.nix` | `modules/home/brave/default.nix` | `gui.programs.brave.*` → `brave.*` |
| `modules/home/gui/programs/chromium/default.nix` | `modules/home/chromium/default.nix` | `gui.programs.chromium.*` → `chromium.*` |
| `modules/home/gui/programs/dbeaver/default.nix` | `modules/home/dbeaver/default.nix` | `gui.programs.dbeaver.*` → `dbeaver.*` |
| `modules/home/gui/programs/element/default.nix` | `modules/home/element/default.nix` | `gui.programs.element.*` → `element.*` |
| `modules/home/gui/programs/firefox/default.nix` | `modules/home/firefox/default.nix` | `gui.programs.firefox.*` → `firefox.*` |
| `modules/home/gui/programs/gparted/default.nix` | `modules/home/gparted/default.nix` | `gui.programs.gparted.*` → `gparted.*` |
| `modules/home/gui/programs/librewolf/default.nix` | `modules/home/librewolf/default.nix` | `gui.programs.librewolf.*` → `librewolf.*` |
| `modules/home/gui/programs/obsidian/default.nix` | `modules/home/obsidian/default.nix` | `gui.programs.obsidian.*` → `obsidian.*` |
| `modules/home/gui/programs/postman/default.nix` | `modules/home/postman/default.nix` | `gui.programs.postman.*` → `postman.*` |
| `modules/home/gui/programs/slack/default.nix` | `modules/home/slack/default.nix` | `gui.programs.slack.*` → `slack.*` |
| `modules/home/gui/programs/spotify/default.nix` | `modules/home/spotify/default.nix` | `gui.programs.spotify.*` → `spotify.*` |
| `modules/home/gui/programs/tidal/default.nix` | `modules/home/tidal/default.nix` | `gui.programs.tidal.*` → `tidal.*` |
| `modules/home/gui/programs/webcord/default.nix` | `modules/home/webcord/default.nix` | `gui.programs.webcord.*` → `webcord.*` |

### NixOS Modules (old → new)

| Old Path | New Path | Option Path Change |
|---|---|---|
| `modules/nixos/core/default.nix` | DELETED (was just an aggregator importing fonts.nix + secrets.nix) |
| `modules/nixos/core/fonts.nix` | `modules/nixos/fonts/default.nix` | (no custom options) |
| `modules/nixos/core/secrets.nix` | `modules/nixos/secrets/default.nix` | (no custom options, but references `wireguard.server.enable`) |
| `modules/nixos/gui/desktop/dunst/default.nix` | `modules/nixos/dunst/default.nix` | `gui.desktop.dunst.*` → `dunst.*` |
| `modules/nixos/gui/desktop/hyprland/default.nix` | `modules/nixos/hyprland/default.nix` | `gui.desktop.hyprland.*` → `hyprland.*` |
| `modules/nixos/gui/desktop/sddm/default.nix` | `modules/nixos/sddm/default.nix` | `gui.desktop.sddm.*` → `sddm.*` |
| `modules/nixos/hardware/nvidia/default.nix` | `modules/nixos/nvidia/default.nix` | `hardware.nvidia.*` → `nvidia.*` |
| `modules/nixos/networking/bridge/default.nix` | `modules/nixos/bridge/default.nix` | `networking.bridge.*` → `bridge.*` |
| `modules/nixos/networking/wg/default.nix` | `modules/nixos/wireguard/default.nix` | `networking.wireguard.server.*` → `wireguard.*` |
| `modules/nixos/programs/ethereum/erigon/default.nix` | `modules/nixos/erigon/default.nix` | `programs.ethereum.erigon.*` → `erigon.*` |
| `modules/nixos/programs/ethereum/geth/default.nix` | `modules/nixos/geth/default.nix` | `programs.ethereum.geth.*` → `geth.*` |
| `modules/nixos/virtualisation/microvm/default.nix` | `modules/nixos/microvm/default.nix` | `virtualisation.microvm.*` → `microvm.*` |

### Consumer Updates

| File | Changes |
|---|---|
| `systems/x86_64-linux/baradur/default.nix` | Update all `fellowship.*` option paths |
| `systems/aarch64-linux/helms-deep/default.nix` | Update `fellowship.networking.bridge.*` → `fellowship.bridge.*`, `fellowship.virtualisation.microvm.*` → `fellowship.microvm.*` |
| `systems/aarch64-darwin/digibook/default.nix` | Update `${namespace}.networking.wireguard.*` → `${namespace}.wireguard.*` |
| `systems/aarch64-darwin/mingabook/default.nix` | Update `${namespace}.networking.wireguard.*` → `${namespace}.wireguard.*` |
| `systems/aarch64-darwin/dbook/default.nix` | No change (only uses `system.name`) |
| `homes/x86_64-linux/arrayofone/default.nix` | Update all `fellowship.gui.*` and `fellowship.home.dev.*` paths |
| `homes/aarch64-darwin/db/default.nix` | Update `fellowship.home.dev*` paths |
| `homes/aarch64-darwin/arrayofone/default.nix` | Update `fellowship.home.dev.enable` |
| `homes/aarch64-darwin/darrenbangsund/default.nix` | Update commented lines (optional) |

---

## Tasks

### Task 1: Flatten darwin modules

**Files:**
- Create: `modules/darwin/system/default.nix`, `modules/darwin/secrets/default.nix`, `modules/darwin/dock/default.nix`, `modules/darwin/fonts/default.nix`, `modules/darwin/wireguard/default.nix`
- Delete: `modules/darwin/core/`, `modules/darwin/networking/`

- [ ] **Step 1:** Create new darwin module directories and move files with updated content. Key changes:
  - `darwin/system/default.nix`: just the `system.name` option (from old core/default.nix, without imports)
  - `darwin/secrets/default.nix`: standalone (was sub-import of core), reference `config.${namespace}.system.name` still works
  - `darwin/dock/default.nix`: unchanged from old core/dock.nix
  - `darwin/fonts/default.nix`: unchanged from old core/fonts.nix
  - `darwin/wireguard/default.nix`: option path changes from `${namespace}.networking.wireguard.server` to `${namespace}.wireguard`

- [ ] **Step 2:** Delete old `modules/darwin/core/` and `modules/darwin/networking/` directories

- [ ] **Step 3:** Verify no dangling references with grep

### Task 2: Flatten home core modules

**Files:**
- Create: `modules/home/packages/default.nix`, `modules/home/env/default.nix`, `modules/home/fonts/default.nix`, `modules/home/git/default.nix`, `modules/home/secrets/default.nix`, `modules/home/shell/default.nix`, `modules/home/ssh/default.nix`, `modules/home/theme/default.nix`, `modules/home/tmux/default.nix`, `modules/home/vscode/default.nix`, `modules/home/zed/default.nix`
- Delete: `modules/home/core/`

- [ ] **Step 1:** Create `modules/home/packages/default.nix` — contains the package list and zed-server home.file from old core/default.nix (NO imports, each file is now standalone)

- [ ] **Step 2:** Move each sub-file to its own module directory. Each file becomes a standalone Snowfall module — wrap in proper module args if needed, remove any dependency on being imported from core/default.nix

- [ ] **Step 3:** Delete old `modules/home/core/`

### Task 3: Flatten home dev modules

**Files:**
- Modify: `modules/home/dev/default.nix`
- Create: `modules/home/dev-db/default.nix`, `modules/home/dev-flutter/default.nix`, `modules/home/dev-go/default.nix`, `modules/home/dev-gql/default.nix`, `modules/home/dev-js/default.nix`
- Delete: `modules/home/dev/modules/`

- [ ] **Step 1:** Update `modules/home/dev/default.nix` — change option from `${namespace}.home.dev` to `${namespace}.dev`, update references to sub-modules from `${namespace}.home.dev_modules.X` to `${namespace}.dev-X`

- [ ] **Step 2:** Create each dev sub-module at top level with updated option paths (e.g., `${namespace}.dev-go` instead of `${namespace}.home.dev_modules.go`)

- [ ] **Step 3:** Delete old `modules/home/dev/modules/` and unused `golangci-lint.nix`

### Task 4: Flatten home gui modules

**Files:**
- Create: 18 module directories under `modules/home/` (dunst, hypridle, hyprland, hyprlock, waybar, brave, chromium, dbeaver, element, firefox, gparted, librewolf, obsidian, postman, slack, spotify, tidal, webcord)
- Delete: `modules/home/gui/`

- [ ] **Step 1:** Move each gui module to `modules/home/<name>/default.nix`, updating option paths from `${namespace}.gui.desktop.<name>` or `${namespace}.gui.programs.<name>` to `${namespace}.<name>`

- [ ] **Step 2:** Delete old `modules/home/gui/`

### Task 5: Flatten nixos modules

**Files:**
- Create: `modules/nixos/fonts/default.nix`, `modules/nixos/secrets/default.nix`, `modules/nixos/dunst/default.nix`, `modules/nixos/hyprland/default.nix`, `modules/nixos/sddm/default.nix`, `modules/nixos/nvidia/default.nix`, `modules/nixos/bridge/default.nix`, `modules/nixos/wireguard/default.nix`, `modules/nixos/erigon/default.nix`, `modules/nixos/geth/default.nix`, `modules/nixos/microvm/default.nix`
- Delete: `modules/nixos/core/`, `modules/nixos/gui/`, `modules/nixos/hardware/`, `modules/nixos/networking/`, `modules/nixos/programs/`, `modules/nixos/virtualisation/`

- [ ] **Step 1:** Create each nixos module at top level with updated option paths. Key changes:
  - `secrets/default.nix`: update WireGuard enable check from `config.${namespace}.networking.wireguard.server.enable` to `config.${namespace}.wireguard.enable`
  - `wireguard/default.nix`: option path from `${namespace}.networking.wireguard.server` to `${namespace}.wireguard`
  - `bridge/default.nix`: from `${namespace}.networking.bridge` to `${namespace}.bridge`
  - `nvidia/default.nix`: from `${namespace}.hardware.nvidia` to `${namespace}.nvidia`
  - `erigon/default.nix`: from `${namespace}.programs.ethereum.erigon` to `${namespace}.erigon`
  - `geth/default.nix`: from `${namespace}.programs.ethereum.geth` to `${namespace}.geth`
  - `microvm/default.nix`: from `${namespace}.virtualisation.microvm` to `${namespace}.microvm`
  - `dunst/default.nix`: from `${namespace}.gui.desktop.dunst` to `${namespace}.dunst`
  - `hyprland/default.nix`: from `${namespace}.gui.desktop.hyprland` to `${namespace}.hyprland`
  - `sddm/default.nix`: from `${namespace}.gui.desktop.sddm` to `${namespace}.sddm`

- [ ] **Step 2:** Delete old directories

### Task 6: Update system configs

**Files:**
- Modify: `systems/x86_64-linux/baradur/default.nix`, `systems/aarch64-linux/helms-deep/default.nix`, `systems/aarch64-darwin/digibook/default.nix`, `systems/aarch64-darwin/mingabook/default.nix`

- [ ] **Step 1:** Update baradur — flatten all `fellowship.*` paths:
  - `fellowship.gui.desktop.dunst.enable` → `fellowship.dunst.enable`
  - `fellowship.gui.desktop.hyprland.enable` → `fellowship.hyprland.enable`
  - `fellowship.gui.desktop.sddm` → `fellowship.sddm`
  - `fellowship.hardware.nvidia.enable` → `fellowship.nvidia.enable`
  - `fellowship.programs.ethereum.erigon` → `fellowship.erigon`
  - `fellowship.programs.ethereum.geth` → `fellowship.geth`
  - `fellowship.networking.wireguard.server` → `fellowship.wireguard`

- [ ] **Step 2:** Update helms-deep:
  - `fellowship.networking.bridge` → `fellowship.bridge`
  - `fellowship.virtualisation.microvm` → `fellowship.microvm`

- [ ] **Step 3:** Update digibook:
  - `${namespace}.networking.wireguard.server` → `${namespace}.wireguard`

- [ ] **Step 4:** Update mingabook:
  - `${namespace}.networking.wireguard.server` → `${namespace}.wireguard`

### Task 7: Update home configs

**Files:**
- Modify: `homes/x86_64-linux/arrayofone/default.nix`, `homes/aarch64-darwin/db/default.nix`, `homes/aarch64-darwin/arrayofone/default.nix`, `homes/aarch64-darwin/darrenbangsund/default.nix`

- [ ] **Step 1:** Update `homes/x86_64-linux/arrayofone/default.nix`:
```nix
  fellowship = {
    dunst.enable = true;
    hypridle.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    waybar.enable = true;
    brave.enable = true;
    firefox.enable = true;
    librewolf.enable = false;
    dbeaver.enable = true;
    element.enable = true;
    gparted.enable = true;
    obsidian.enable = true;
    postman.enable = true;
    slack.enable = true;
    tidal.enable = true;
    webcord.enable = true;
    dev.enable = true;
  };
```

- [ ] **Step 2:** Update `homes/aarch64-darwin/db/default.nix`:
```nix
  fellowship = {
    dev.enable = true;
    dev-go.enable = lib.mkForce false;
    dev-flutter.enable = lib.mkForce false;
  };
```

- [ ] **Step 3:** Update `homes/aarch64-darwin/arrayofone/default.nix`:
```nix
  fellowship.dev.enable = false;
```

- [ ] **Step 4:** Update commented lines in `homes/aarch64-darwin/darrenbangsund/default.nix`

### Task 8: Clean up and verify

- [ ] **Step 1:** Run `grep -r 'gui\.desktop\|gui\.programs\|home\.dev_modules\|home\.dev\.\|hardware\.nvidia\|programs\.ethereum\|networking\.wireguard\|networking\.bridge\|virtualisation\.microvm' modules/ systems/ homes/` to find any remaining old option paths

- [ ] **Step 2:** Verify no old directories remain

- [ ] **Step 3:** Commit

### Task 9: Test build

- [ ] **Step 1:** Run `nix build .#darwinConfigurations.mingabook.system` (or `sys test`) to verify darwin builds

- [ ] **Step 2:** Fix any evaluation errors
