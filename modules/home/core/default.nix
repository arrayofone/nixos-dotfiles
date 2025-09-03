{
  pkgs,
  ...
}:
{
  imports = [
    ./editor.nix
    ./env.nix
    # ./fonts.nix
    ./secrets.nix
    ./shell.nix
    # ./theme.nix
  ];

  home.packages = with pkgs; [
    # Security & Secrets
    age
    gnupg
    openssl
    sops
    ssh-to-age

    # Shell & Core Utils
    bash
    bat
    btop
    curl
    htop
    jq
    lf
    lsof
    # neofetch
    netcat
    ripgrep
    tmux
    wget
    zellij
    zsh

    # Version Control & Git
    gh
    git
    git-lfs
    lazygit
    tig

    # Editors
    neovim
    vim

    # Build Tools & Compilers
    cmake
    gcc
    gnumake
    go-task
    meson
    ninja
    pkg-config

    # Container & Orchestration
    docker
    docker-compose
    k9s
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    podman
    podman-compose
    podman-tui
    stern

    # Development Tools
    direnv
    entr
    fd
    fzf
    gdb
    hyperfine
    just
    lldb
    mkcert
    nix-direnv
    parallel
    pre-commit
    protols
    # strace
    tokei
    tree
    watchman
    xh

    # Network Tools
    bind
    curl
    dig
    httpie
    iperf3
    mtr
    nmap
    socat
    tcpdump
    # traceroute
    wireguard-tools

    # Data Processing
    dasel
    gron
    jless
    miller
    yq

    # Archive Tools
    p7zip
    unzip
    zip

    # System Monitoring
    bandwhich
    bottom
    duf
    dust
    eza
    lsd
    ncdu
    procs
    sd

    # Development Languages Support
    # (Language-specific packages should be in their respective modules)
    # but these are useful across languages:
    asdf-vm
    cachix
    devbox
    mise
    nix-diff
    nix-tree
    nixpkgs-fmt
    statix
  ];
}
