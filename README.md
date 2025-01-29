<div align="center">

# ❄️ Fellowship
### *arrayofone's NixOS Configuration*

*Declarative system configuration with NixOS & nix-darwin*

**[🐧 Linux Guide](docs/baradur.md)** • **[🍎 macOS Guide](docs/digibook.md)**

</div>

---

## 🏰 Systems Overview

| System | Architecture | OS | Purpose |
|--------|--------------|----|---------| 
| **baradur** | `x86_64-linux` | NixOS 24.05 | Desktop (Hyprland) |
| **digibook** | `aarch64-darwin` | macOS | Development Laptop |

## 🚀 Quick Start

### Prerequisites
```bash
# Install Nix with flakes
curl -L https://nixos.org/nix/install | sh
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Install Task runner
nix-shell -p go-task
```

### Deploy
```bash
git clone <repo> ~/.sys && cd ~/.sys

# Linux
task deploy:nixos

# macOS  
task deploy:darwin
```

## 📁 Structure

```
.sys/
├── flake.nix              # Main entry point
├── systems/               # Host configurations
├── modules/               # Reusable modules  
├── homes/                 # User configurations
├── packages/              # Custom packages
├── shells/                # Development environments
└── secrets/               # Encrypted secrets
```

## ⚙️ Commands

| Operation | Linux | macOS |
|-----------|-------|-------|
| **Deploy** | `task deploy:nixos` | `task deploy:darwin` |
| **Switch** | `task switch:nixos` | `task switch:darwin` |
| **Home** | `task home:nixos` | `task home:darwin` |

### Common
```bash
task update      # Update flake inputs
task dev         # Development shell
task maintenance # Weekly cleanup
```

## 📚 Guides

- **[🐧 baradur](docs/baradur.md)** - Linux system setup
- **[🍎 digibook](docs/digibook.md)** - macOS system setup

---

<div align="center">

*Built with ❄️ [NixOS](https://nixos.org) and [Snowfall Library](https://snowfall.org)*

</div>