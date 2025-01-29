<div align="center">

# 🐧 baradur - Linux Desktop
### *NixOS Gaming & Development Workstation*

*NixOS • Hyprland • NVIDIA • Development*

**[🚀 Quick Setup](#-quick-setup)** • **[⚙️ Configuration](#-configuration)** • **[🔧 Maintenance](#-maintenance)**

</div>

---

## 📋 System Specifications

| Component | Details |
|-----------|---------|
| **Architecture** | `x86_64-linux` |
| **OS** | NixOS 24.05 |
| **Window Manager** | Hyprland |
| **Display Manager** | SDDM |
| **Graphics** | NVIDIA with CUDA |
| **User** | arrayofone |

## 🚀 Quick Setup

### Prerequisites
```bash
# Ensure you have NixOS installed
nix-shell -p go-task
```

### Installation
```bash
# Clone repository
git clone git@github.com:arrayofone/nixos-dotfiles.git ~/.sys && cd ~/.sys

# Generate hardware config (new installations)
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix systems/x86_64-linux/baradur/

# Deploy system
task deploy:nixos
```

### Verification
```bash
task info:system
task service:status -- sddm
```

## ⚙️ Configuration

### Desktop Environment
- **Hyprland** - Tiling window manager
- **Waybar** - Status bar
- **SDDM** - Display manager with custom theme
- **Catppuccin** - System-wide theming

### Development Stack
```bash
# Enter development shell
task dev

# Available tools:
go version                     # Go 1.23
node --version                 # Node.js LTS
docker --version               # Docker
kubectl version                # Kubernetes CLI
```

### System Services
- **PipeWire** - Audio system
- **CUPS** - Printing
- **SSH** - Remote access
- **Firewall** - Enabled with specific ports

## 🔧 Maintenance

### Daily Commands
```bash
# Apply changes
task switch:nixos

# Apply user config
task home:nixos

# Complete deployment
task deploy:nixos
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
task debug:nixos

# Check system logs
journalctl -xeu <service>

# Graphics issues
nvidia-smi
hyprctl systeminfo
```

---

<div align="center">

**[⬅️ Back to Main](../README.md)** • **[🍎 macOS Guide](digibook.md)**

</div>
