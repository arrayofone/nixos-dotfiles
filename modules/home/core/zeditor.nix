{
  lib,
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    installRemoteServer = true;
    extraPackages = [ pkgs.nixd ];

    themes = { };
    userKeymaps = [ ];
    userTasks = [ ];

    # Extensions organized by category
    extensions = [
      # Themes
      "catppuccin"
      "catppuccin-icons"
      "dracula"
      "dune-theme"
      "github-dark-default"
      "github-theme"
      "gruvbox-material"
      "material-dark"
      "material-theme"
      "material-icon-theme"
      "macos-classic"
      "monospace-theme"
      "monospace-icon-theme"
      "one-dark-pro"
      "tailwind-theme"
      "the-dark-side"
      "tokyo-night"

      # Language Support
      "assembly"
      "csv"
      "deno"
      "graphql"
      "html"
      "ini"
      "java"
      "kotlin"
      "nix"
      "proto"
      "sql"
      "toml"
      "xml"
      "zig"

      # Development Tools
      "docker-compose"
      "dockerfile"
      "git-firefly"
      "golangci-lint"
      "helm"
      "http"
      "make"
      "nginx"
      "terraform"
      "tmux"

      # Utilities
      "brainfuck"
      "log"
      "mermaid"
      "perplexity"
    ];

    userSettings = {
      # Core Settings
      auto_update = false;
      vim_mode = false;
      base_keymap = "VSCode";
      hour_format = "hour24";
      load_direnv = "shell_hook";

      # UI and Theme Settings
      theme = lib.mkDefault {
        mode = "system";
        light = "Tokyo Night Storm";
        dark = "Tokyo Night";
      };
      ui_font_family = lib.mkDefault "IntoneMono Nerd Font Mono";
      ui_font_size = lib.mkDefault 12;
      buffer_font_family = lib.mkDefault "IntoneMono Nerd Font Mono";
      buffer_font_size = lib.mkDefault 12;
      show_whitespaces = "boundary";

      # Editor Settings
      soft_wrap = "none";
      tab_size = 2;
      hard_tabs = false;
      show_copilot_suggestions = true;
      auto_save = "on_focus_change";
      format_on_save = "on";
      ensure_final_newline_on_save = true;
      remove_trailing_whitespace_on_save = true;
      show_inline_completions = true;

      # Project Panel Settings
      project_panel = {
        button = true;
        dock = "left";
        git_status = true;
        auto_fold_dirs = true;
        indent_size = 20;
      };

      # Outline Panel Settings
      outline_panel = {
        button = true;
        dock = "right";
      };

      # Collaboration Settings
      collaboration_panel = {
        button = false;
      };

      # Chat Panel Settings
      chat_panel = {
        button = true;
        dock = "right";
      };

      # Notification Settings
      notification_panel = {
        button = true;
        dock = "bottom";
      };

      # Terminal Settings
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        font_family = "IntoneMono Nerd Font Mono";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
        env = {
          TERM = "ghostty";
        };
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
      };

      # Git Settings
      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = true;
          delay_ms = 600;
        };
      };

      # Language Server Settings
      lsp = {
        # rust-analyzer = {
        #   binary = {
        #     path = lib.getExe pkgs.rust-analyzer;
        #     path_lookup = true;
        #   };
        # };
        nixd = { };
        nil = { };
        nix = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
        protobuf-language-server = {
          binary = {
            path = lib.getExe pkgs.protols;
          };
        };
      };

      # Language Server Configurations
      "[language_servers.claude-code-server]" = {
        name = "Claude Code Server";
        languages = [
          "Rust"
          "JavaScript"
          "TypeScript"
          "Python"
          "Markdown"
          "Go"
          "Java"
        ];
      };

      # Node.js Configuration
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      # Language-specific Settings
      languages = {
        "JavaScript" = {
          tab_size = 2;
          hard_tabs = false;
        };
        "TypeScript" = {
          tab_size = 2;
          hard_tabs = false;
        };
        "JSON" = {
          tab_size = 2;
          hard_tabs = false;
        };
        "Nix" = {
          tab_size = 4;
          hard_tabs = true;
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
        "Go" = {
          tab_size = 4;
          hard_tabs = true;
        };
      };

      # Assistant/AI Settings
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;
        # Provider Options:
        # zed.dev models { claude-3-5-sonnet-latest } requires github connected
        # anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest } requires API_KEY
        # copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };
        # inline_alternatives = [
        #   {
        #     provider = "copilot_chat";
        #     model = "gpt-3.5-turbo";
        #   }
        # ];
      };

      # Feature Flags
      features = {
        edit_prediction_provider = "none";
        copilot = true;
      };

      # File associations
      file_types = {
        "Dockerfile" = [ "Dockerfile*" ];
        "YAML" = [
          "*.yml"
          "*.yaml"
        ];
        "Shell Script" = [
          "*.zsh"
          "*.bash"
        ];
      };

      # Preview Settings
      preview_tabs = {
        enabled = true;
        enable_preview_from_file_finder = true;
        enable_preview_from_code_navigation = true;
      };

      # Search Settings
      search = {
        whole_word = false;
        case_sensitive = false;
        include_ignored = false;
        regex = false;
      };
    };
  };
}
