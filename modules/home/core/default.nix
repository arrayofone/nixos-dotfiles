{
  pkgs,
  ...
}:
{
  imports = [
    # ./editor.nix
    ./env.nix
    ./fonts.nix
    ./secrets.nix
    ./shell.nix
    ./terminal.nix
    ./theme.nix
    ./zeditor.nix
  ];

  home.file.".zed_server" = {
    source = "${pkgs.zed-editor.remote_server}/bin";
    recursive = true;
  };

  home.packages = with pkgs; [
    age
    bash
    bat
    btop
    gcc
    gemini-cli
    gh
    git
    gnupg
    gnumake
    htop
    jq
    lf
    lsof
    #neofetch
    neovim
    netcat
    openssl
    protols
    ripgrep
    sops
    tmux
    vim-full
    wget
    wireguard-tools
    zellij

    # TODO: are these needed for all systems? - probably not
    # awscli2
    docker
    docker-compose
    emacs
    k9s
    # kotlin-language-server
    kubectl
    kubectx
    kubernetes-helm
    lazydocker
    lazysql
    minikube
    nil
    nixfmt-rfc-style
    oxker
    podman
    podman-compose
    podman-tui
    protobuf

    alacritty
    # foot
    ghostty
    kitty
    nixfmt
    zip
    unzip

    claude-code
    claude-monitor
  ];
}
