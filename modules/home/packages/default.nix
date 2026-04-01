{
  namespace,
  pkgs,
  ...
}:
{
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
