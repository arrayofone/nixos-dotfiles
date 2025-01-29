{ pkgs, ... }:

pkgs.mkShell {
  name = "nix-digits";

  packages = with pkgs; [
    # go
    delve
    go_1_23
    go-ethereum
    gopls
    gotools
    go-tools
    golangci-lint

    # java
    # jdk21_headless

    # js
    deno
    nodejs
    typescript
    yarn

    # tools
    bash
    docker
    docker-compose
    gcc
    gh
    git
    gnupg
    gnumake
    htop
    jq
    k9s
    kubectl
    kubectx
    kubernetes-helm
    lazydocker
    lazysql
    lf
    minikube
    neofetch
    neovim
    openssl
    podman
    podman-compose
    podman-tui
    postgresql
    protobuf
    ripgrep
    vim-full
  ];
}
