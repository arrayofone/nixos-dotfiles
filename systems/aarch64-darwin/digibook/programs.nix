{ pkgs, ... }:
{
  programs = {
    _1password = {
      enable = true;
      package = pkgs._1password-cli;
    };

    _1password-gui = {
      enable = true;
      package = pkgs._1password-gui;
    };

    arqbackup = {
      enable = false;
      # package
    };

    bash = {
      enable = false;
      completion = {
        enable = true;
        package = pkgs.bash-completion;
      };
      interactiveShellInit = "";
    };

    direnv = {
      enable = true;
      package = pkgs.direnv;
      direnvrcExtra = "";
      # finalPackage
      loadInNixShell = true;
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
      settings = { };
      silent = false;
    };

    fish = {
      enable = false;
      package = pkgs.fish;
      # babelfishPackage
      interactiveShellInit = "";
      loginShellInit = "";
      promptInit = "";
      shellAliases = { };
      shellInit = "";
      useBabelfish = false;
      vendor = {
        completions.enable = false;
        config.enable = false;
        functions.enable = false;
      };
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };

    info.enable = true;

    man.enable = true;

    nix-index = {
      enable = true;
      package = pkgs.nix-index;
    };

    ssh = {
      extraConfig = "";
      knownHosts = { };
    };

    tmux = {
      enable = true;
      enableFzf = true;
      enableMouse = true;
      enableSensible = true;
      enableVim = false;
      extraConfig = "";
      iTerm2 = false;
      tmuxOptions = { };
    };

    vim = {
      enable = true;
      enableSensible = true;
      extraKnownPlugins = { };
      plugins = [ ];
      vimConfig = "";
      vimOptions = { };
    };

    # zsh = {
    #   enable = true;
    #   enableAutosuggestions = false;
    #   enableBashCompletion = false;
    #   enableCompletion = false;
    #   enableFastSyntaxHighlighting = false;
    #   enableFzfCompletion = false;
    #   enableFzfGit = false;
    #   enableFzfHistory = false;
    #   enableGlobalCompInit = false;
    #   enableSyntaxHighlighting = false;
    #   interactiveShellInit = "";
    #   loginShellInit = "";
    #   promptInit = "";
    #   shellInit = "";
    #   variables = { };
    # };
  };
}
