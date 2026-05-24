{ lib, config, namespace, ... }:
let
  cfg = config.${namespace}.claude;
in
{
  options.${namespace}.claude = {
    enable = lib.mkEnableOption "sync Claude Code config from the Obsidian vault";

    vaultPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Documents/A01/Claude";
      description = "Path to the Claude config directory inside the Obsidian vault.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".claude/CLAUDE.md".source =
        config.lib.file.mkOutOfStoreSymlink "${cfg.vaultPath}/CLAUDE.md";
      ".claude/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${cfg.vaultPath}/settings.json";
    };

    home.activation.claudeVaultLinks =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        VAULT=${lib.escapeShellArg cfg.vaultPath}
        CLAUDE_DIR=${lib.escapeShellArg "${config.home.homeDirectory}/.claude"}

        # Per-project memory symlinks: vault/projects/<key>/memory -> ~/.claude/projects/<key>/memory
        if [ -d "$VAULT/projects" ]; then
          for project_dir in "$VAULT"/projects/*/; do
            [ -d "$project_dir" ] || continue
            key=$(basename "$project_dir")
            if [ -d "$project_dir/memory" ]; then
              $DRY_RUN_CMD mkdir -p "$CLAUDE_DIR/projects/$key"
              target="$CLAUDE_DIR/projects/$key/memory"
              if [ ! -L "$target" ]; then
                # Don't clobber a real directory — only replace if it doesn't exist
                if [ ! -e "$target" ]; then
                  $DRY_RUN_CMD ln -s "$project_dir/memory" "$target"
                fi
              fi
            fi
          done
        fi

        # User-authored skills symlinks: vault/skills/<name> -> ~/.claude/skills/<name>
        if [ -d "$VAULT/skills" ]; then
          $DRY_RUN_CMD mkdir -p "$CLAUDE_DIR/skills"
          for skill_dir in "$VAULT"/skills/*/; do
            [ -d "$skill_dir" ] || continue
            name=$(basename "$skill_dir")
            target="$CLAUDE_DIR/skills/$name"
            if [ ! -L "$target" ] && [ ! -e "$target" ]; then
              $DRY_RUN_CMD ln -s "$skill_dir" "$target"
            fi
          done
        fi
      '';
  };
}
