<div align="center">

# 🍎 digibook - macOS Laptop
### *Apple Silicon Development Machine*

*macOS • nix-darwin • Homebrew • Apple Silicon*

**[🚀 Quick Setup](#-quick-setup)** • **[⚙️ Configuration](#-configuration)** • **[🔧 Maintenance](#-maintenance)**

</div>

---

## 📋 System Specifications

| Component | Details |
|-----------|---------|
| **Architecture** | `aarch64-darwin` |
| **OS** | macOS (Apple Silicon) |
| **Package Manager** | nix-darwin + Homebrew |
| **User** | db |
| **Compatibility** | Rosetta 2 enabled |

## 🚀 Quick Setup

### Prerequisites
```bash
# Install Nix with flakes enabled
curl -L https://nixos.org/nix/install | sh
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Install Task runner
nix-shell -p go-task
```

### Installation
```bash
# Clone repository
git clone git@github.com:arrayofone/nixos-dotfiles.git ~/.sys && cd ~/.sys

# Bootstrap nix-darwin (first time only)
nix run nix-darwin -- switch --flake .#digibook

# Deploy system
task deploy:darwin
```

### Verification
```bash
task info:system
brew --version
```

## ⚙️ Configuration

### System Features
- **Touch ID** for sudo commands
- **Rosetta 2** for x86_64 compatibility
- **Homebrew** integration via nix-homebrew
- **Universal binary** support

### Development Stack
```bash
# Enter development shell
task dev

# Available tools:
go version                     # Go 1.23
node --version                 # Node.js LTS
docker --version               # Docker (via OrbStack)
kubectl version                # Kubernetes CLI
```

### Homebrew Apps
#### Browsers
- Arc, Brave, Firefox, Chrome, Zen

#### Development
- Cursor, VS Code, IntelliJ IDEA, DataGrip
- Bruno, Postman, DBeaver

#### Productivity
- Obsidian, Slack, Discord, Zoom
- HiddenBar, iStat Menus

#### System
- OrbStack (Docker alternative)
- Google Cloud SDK

## 🔧 Maintenance

### Daily Commands
```bash
# Apply changes
task switch:darwin

# Apply user config
task home:darwin

# Complete deployment
task deploy:darwin
```

### Weekly Maintenance
```bash
task maintenance               # Automated cleanup
task update                    # Update flake inputs
task gc                        # Garbage collection
```

### Troubleshooting
```bash
# Debug build failures
task debug:darwin

# Check Homebrew
brew doctor

# Clear Nix daemon cache
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon
```

---

<div align="center">

**[⬅️ Back to Main](../README.md)** • **[🐧 Linux Guide](baradur.md)**

</div>
