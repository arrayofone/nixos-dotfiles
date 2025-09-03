# Core Development Packages

This module provides a comprehensive set of development tools and utilities for a modern development environment. All packages listed below are enabled by default when using this home configuration.

## 📦 Installed Commands

### 🔐 Security & Secrets Management

| Package | Command(s) | Description |
|---------|------------|-------------|
| **age** | `age`, `age-keygen` | Modern file encryption tool with small keys |
| **gnupg** | `gpg`, `gpg-agent`, `gpgv` | GNU Privacy Guard for encryption and digital signatures |
| **openssl** | `openssl` | Cryptography toolkit and SSL/TLS library |
| **sops** | `sops` | Encrypted secrets management for Git repos |
| **ssh-to-age** | `ssh-to-age` | Convert SSH keys to age encryption keys |

### 🐚 Shell & Core Utilities

| Package | Command(s) | Description |
|---------|------------|-------------|
| **bash** | `bash` | Bourne Again Shell - standard Unix shell |
| **bat** | `bat` | Modern `cat` replacement with syntax highlighting |
| **btop** | `btop` | Beautiful resource monitor with graphs and process management |
| **curl** | `curl` | Transfer data from/to servers via various protocols |
| **htop** | `htop` | Interactive process viewer and system monitor |
| **jq** | `jq` | Command-line JSON processor and transformer |
| **lf** | `lf` | Terminal file manager written in Go |
| **lsof** | `lsof` | List open files and network connections |
| **netcat** | `nc`, `netcat` | Network utility for reading/writing TCP/UDP |
| **ripgrep** | `rg` | Extremely fast recursive text search |
| **tmux** | `tmux` | Terminal multiplexer for managing sessions |
| **wget** | `wget` | Non-interactive network file downloader |
| **zellij** | `zellij` | Modern terminal workspace and multiplexer |
| **zsh** | `zsh` | Z Shell with advanced features and customization |

### 📝 Version Control & Git

| Package | Command(s) | Description |
|---------|------------|-------------|
| **gh** | `gh` | Official GitHub CLI for PRs, issues, and more |
| **git** | `git` | Distributed version control system |
| **git-lfs** | `git-lfs` | Git extension for large file versioning |
| **lazygit** | `lazygit` | Terminal UI for Git with intuitive commands |
| **tig** | `tig` | Text-mode interface for Git repositories |

### ✏️ Text Editors

| Package | Command(s) | Description |
|---------|------------|-------------|
| **neovim** | `nvim`, `nvim-qt` | Hyperextensible Vim-based text editor |
| **vim** | `vim`, `vi` | Vi Improved - ubiquitous text editor |

### 🔨 Build Tools & Compilers

| Package | Command(s) | Description |
|---------|------------|-------------|
| **cmake** | `cmake`, `ctest`, `cpack` | Cross-platform build system generator |
| **gcc** | `gcc`, `g++`, `cpp`, `c++` | GNU Compiler Collection for C/C++ |
| **gnumake** | `make`, `gmake` | Build automation tool using Makefiles |
| **go-task** | `task` | Modern task runner and build tool |
| **meson** | `meson` | Fast and user-friendly build system |
| **ninja** | `ninja` | Small, fast build system |
| **pkg-config** | `pkg-config` | Helper tool for compiling applications and libraries |

### 🐳 Container & Orchestration

| Package | Command(s) | Description |
|---------|------------|-------------|
| **docker** | `docker` | Container platform for building and running apps |
| **docker-compose** | `docker-compose` | Multi-container Docker application orchestration |
| **k9s** | `k9s` | Terminal UI for Kubernetes cluster management |
| **kubectl** | `kubectl` | Kubernetes command-line tool |
| **kubectx** | `kubectx`, `kubens` | Fast way to switch between clusters and namespaces |
| **kubernetes-helm** | `helm` | Package manager for Kubernetes |
| **kustomize** | `kustomize` | Kubernetes configuration customization |
| **podman** | `podman` | Daemonless container engine alternative to Docker |
| **podman-compose** | `podman-compose` | Docker Compose compatible tool for Podman |
| **podman-tui** | `podman-tui` | Terminal UI for Podman container management |
| **stern** | `stern` | Multi-pod and container log tailing for Kubernetes |

### 🛠️ Development Tools

| Package | Command(s) | Description |
|---------|------------|-------------|
| **direnv** | `direnv` | Load/unload environment variables based on directory |
| **entr** | `entr` | Run arbitrary commands when files change |
| **fd** | `fd` | Fast and user-friendly alternative to `find` |
| **fzf** | `fzf`, `fzf-tmux` | Command-line fuzzy finder for any list |
| **gdb** | `gdb` | GNU Debugger for C/C++ and other languages |
| **hyperfine** | `hyperfine` | Command-line benchmarking tool |
| **just** | `just` | Handy command runner like `make` but simpler |
| **lldb** | `lldb` | LLVM debugger with better C++ support |
| **mkcert** | `mkcert` | Create locally-trusted development certificates |
| **nix-direnv** | `nix-direnv` | Fast, persistent direnv integration for Nix |
| **parallel** | `parallel` | Execute jobs in parallel using shell commands |
| **pre-commit** | `pre-commit` | Framework for managing Git pre-commit hooks |
| **protols** | `protols` | Protocol Buffers language server |
| **tokei** | `tokei` | Count lines of code quickly and accurately |
| **tree** | `tree` | Display directory contents as a tree |
| **watchman** | `watchman`, `watchman-make` | File watching service by Facebook |
| **xh** | `xh`, `xhs` | Friendly HTTP/HTTPS client like HTTPie but faster |

### 🌐 Network Tools

| Package | Command(s) | Description |
|---------|------------|-------------|
| **bind** | `dig`, `host`, `nslookup`, `nsupdate` | DNS utilities for querying and debugging |
| **curl** | `curl` | Transfer data via URLs with protocol support |
| **dig** | `dig` | DNS lookup tool for querying DNS servers |
| **httpie** | `http`, `https` | User-friendly HTTP client for testing APIs |
| **iperf3** | `iperf3` | Network bandwidth measurement tool |
| **mtr** | `mtr` | Network diagnostic combining ping and traceroute |
| **nmap** | `nmap`, `ncat` | Network discovery and security auditing |
| **socat** | `socat` | Multipurpose relay for bidirectional data transfer |
| **tcpdump** | `tcpdump` | Packet analyzer for network troubleshooting |
| **wireguard-tools** | `wg`, `wg-quick` | Tools for WireGuard VPN configuration |

### 📊 Data Processing

| Package | Command(s) | Description |
|---------|------------|-------------|
| **dasel** | `dasel` | Query and update data structures (JSON, YAML, TOML) |
| **gron** | `gron`, `ungron` | Make JSON greppable by transforming it |
| **jless** | `jless` | Command-line JSON viewer with vim keybindings |
| **miller** | `mlr` | Like awk, sed, cut for CSV, TSV, and JSON |
| **yq** | `yq` | Process YAML documents like jq processes JSON |

### 📦 Archive Tools

| Package | Command(s) | Description |
|---------|------------|-------------|
| **p7zip** | `7z`, `7za`, `7zr` | File archiver with high compression ratio |
| **unzip** | `unzip`, `unzipsfx` | Extract files from ZIP archives |
| **zip** | `zip`, `zipcloak`, `zipnote`, `zipsplit` | Create and modify ZIP archives |

### 📈 System Monitoring

| Package | Command(s) | Description |
|---------|------------|-------------|
| **bandwhich** | `bandwhich` | Display network utilization by process |
| **bottom** | `btm` | Cross-platform graphical process/system monitor |
| **duf** | `duf` | Disk usage/free utility with better output |
| **dust** | `dust` | More intuitive version of `du` |
| **eza** | `eza` | Modern replacement for `ls` with colors and icons |
| **lsd** | `lsd` | Alternative `ls` with icons and tree view |
| **ncdu** | `ncdu` | NCurses disk usage analyzer |
| **procs** | `procs` | Modern replacement for `ps` with better output |
| **sd** | `sd` | Intuitive find and replace (better than sed) |

### 🔧 Development Environment Management

| Package | Command(s) | Description |
|---------|------------|-------------|
| **asdf-vm** | `asdf` | Manage multiple runtime versions (Node, Python, etc.) |
| **cachix** | `cachix` | Binary cache hosting for Nix |
| **devbox** | `devbox` | Create isolated development environments |
| **mise** | `mise` | Fast polyglot runtime manager (asdf rust clone) |
| **nix-diff** | `nix-diff` | Compare Nix derivations to understand changes |
| **nix-tree** | `nix-tree` | Interactively browse Nix store dependencies |
| **nixpkgs-fmt** | `nixpkgs-fmt` | Format Nix code consistently |
| **statix** | `statix` | Lints and fixes antipatterns in Nix code |

## 📖 Common Aliases

Many users create aliases for modern replacements:

```bash
alias ls='eza'
alias ll='eza -la'
alias cat='bat'
alias find='fd'
alias ps='procs'
alias du='dust'
alias top='btop'
alias htop='btop'
alias grep='rg'
```

## 🔍 Quick Command Reference

### Most Used Commands

- **File Operations**: `fd`, `rg`, `bat`, `eza`, `tree`
- **Git Workflow**: `git`, `gh`, `lazygit`, `tig`
- **Container Management**: `docker`, `podman`, `k9s`, `kubectl`
- **Process Monitoring**: `btop`, `htop`, `procs`
- **Network Tools**: `curl`, `wget`, `dig`, `mtr`
- **Data Processing**: `jq`, `yq`, `dasel`
- **Development**: `make`, `task`, `just`, `direnv`

---

*This module is part of the dotfiles home configuration and provides essential development tools for a productive workflow.*
