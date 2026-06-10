{
  namespace,
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.${namespace}.packages;

  # Bleeding-edge nixpkgs (master). Re-imported with our channel config because a raw
  # input import does not inherit the flake's `channels-config`. Lazily evaluated — only
  # forced when `claudeCodeFromMaster` is enabled, so opted-out hosts pay nothing.
  masterPkgs = import inputs.nixpkgs-master {
    inherit (pkgs.stdenv.hostPlatform) system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-38.8.4"
        "nodejs-20.20.2"
        "nodejs-slim-20.20.2"
      ];
    };
  };

  claudeCode = if cfg.claudeCodeFromMaster then masterPkgs.claude-code else pkgs.claude-code;
in
{
  options.${namespace}.packages.claudeCodeFromMaster =
    lib.mkEnableOption "install claude-code from nixpkgs master instead of nixos-unstable";

  config = {
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
        claudeCode
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

        wget
        wireguard-tools
        zellij
        zip
      ]
      ++ [
        pkgs.${namespace}.sys
      ];
  };
}
