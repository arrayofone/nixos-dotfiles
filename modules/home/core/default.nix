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

  home.packages =
    with pkgs;
    [
      age
      alacritty
      bash
      bat
      btop
      claude-code
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
      kitty
      lf
      lsof
      neofetch
      neovim
      netcat
      nixd
      openssl
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
      nixfmt
      oxker
      podman
      podman-compose
      podman-tui
      protobuf

      alacritty
      # foot
      # ghostty
      kitty
      nixfmt
      zip
      unzip

      claude-code
      claude-monitor
    ]
    ++ [
      pkgs.${namespace}.sys
    ];
}
