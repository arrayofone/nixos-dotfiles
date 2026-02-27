# @gitian:module Core home-manager module — imported by every user on every host.
# Aggregates shell, git, SSH, secrets, theming, editor config, and the base package set.
# See [[secrets]] for how SOPS secrets are wired into the home environment.
{
  namespace,
  pkgs,
  ...
}:
{
  imports = [
    # ./editor.nix
    ./env.nix
    ./fonts.nix
    ./git.nix
    ./secrets.nix
    ./shell.nix
    ./ssh.nix
    ./theme.nix
    ./zeditor.nix
  ];

  home.file.".zed_server" = {
    source = "${pkgs.zed-editor.remote_server}/bin";
    recursive = true;
  };

  home.packages =
    with pkgs;
    [
      age
      alacritty
      bash
      bat
      btop
      claude-code
      claude-monitor
      deno
      docker
      docker-compose
      gcc
      gemini-cli
      gh
      git
      gnupg
      gnumake
      go-task
      google-cloud-sdk
      htop
      jq
      k9s
      kitty
      kubectl
      kubectx
      kubernetes-helm
      lf
      lsof
      fastfetch
      lazycli
      lazydocker
      lazygit
      lazyjournal
      lazynpm
      lazysql
      lazyssh
      lazyworktree
      minikube
      neovim
      netcat
      nixd
      nixfmt
      openssl
      parallel
      podman
      podman-compose
      podman-tui
      protobuf
      protols
      ripgrep
      sops
      tmux
      unzip
      vim-full
      wget
      wireguard-tools
      zellij
      zip
    ]
    ++ [
      pkgs.${namespace}.sys
    ];
}
