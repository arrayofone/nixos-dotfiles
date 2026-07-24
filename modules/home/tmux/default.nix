{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.tmux;
in
{
  options.${namespace}.tmux = {
    enable = lib.mkEnableOption "tmux" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      terminal = "tmux-256color";
      historyLimit = 50000;
      escapeTime = 10;
      baseIndex = 1;
      keyMode = "vi";
      extraConfig = ''
        # Enable true color support
        set -ag terminal-overrides ",xterm-256color:RGB"

        # Renumber windows when one is closed
        set -g renumber-windows on
      '';
    };
  };
}
