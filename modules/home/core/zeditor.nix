{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.home.programs.zeditor;
in
{
  options.${namespace}.home.programs.zeditor = {
    nodePath = lib.mkOption {
      type = lib.types.str;
      default = "/run/current-system/sw/bin/node";
      description = "Path to node executable for Zed";
    };
    npmPath = lib.mkOption {
      type = lib.types.str;
      default = "/run/current-system/sw/bin/npm";
      description = "Path to npm executable for Zed";
    };
  };

  config.programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    installRemoteServer = true;
    extraPackages = [ pkgs.nixd ];

    themes = { };
    userKeymaps = [ ];
    userTasks = [ ];

    # Extensions organized by category
    extensions = [
      # Icons
      "bearded-icon-theme"
      "catppuccin-icons"
      "charmed-icons"
      "chawyehsu-vscode-icons"
      "clean-vscode-icons"
      "colored-zed-icons-theme"
      "icons-modern-material"
      "jetbrains-icons"
      "jetbrains-new-ui-icons"
      "material-icon-theme"
      "modern-icons"
      "monospace-icon-theme"
      "openmoji-icons"
      "phosphor-icons-theme"
      "seti-icons"
      "symbols"
      "vscode-icons"
      "vscode-great-icons"

      # Language Support
      "assembly"
      "csv"
      "dart"
      "deno"
      "flatbuffers"
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

      # Themes
      "0x96f"
      "0xtz"
      "1984-theme"
      "adaltas-theme"
      "adech"
      "adwaita"
      "adwaita-pastel"
      "aesthetic-theme"
      "alabaster"
      "alabaster-dark"
      "amber-monochrome-monitor-crt-phosphor"
      "andromeda"
      "anthracite-theme"
      "anya"
      "anysphere-theme"
      "apisartisan"
      "aquarium-theme"
      "arctic-depth"
      "ariake"
      "asteroid"
      "atomize"
      "axolosin"
      "aylin-theme"
      "aystra"
      "ayu-darker"
      "azutiku-theme"
      "bamboo-theme"
      "barbenheimer"
      "base16"
      "batman"
      "beanseeds-pro"
      "bearded"
      "becker-theme"
      "blackfox"
      "blackrain-theme"
      "blackula"
      "blade-runner-2049"
      "blanche"
      "blankeos-zen"
      "blinds-theme"
      "bluloco-theme"
      "brook-code-theme"
      "bubblegum"
      "call-trans-opt-received"
      "catbox"
      "catppuccin"
      "catppuccin-blur"
      "catppuccin-blur-plus"
      "chai-theme"
      "chanterelle"
      "chaos-theory-theme"
      "chatgpt"
      "chocolate"
      "cisco-theme"
      "city-lights"
      "claude-code-inspired-dark"
      "cobalt2"
      "codely-theme"
      "codesandbox-theme"
      "codestackr"
      "colorizer"
      "cosmos"
      "crimson-theme"
      "crystal-theme"
      "cursor"
      "cyan-light-theme"
      "darcula-dark"
      "darcula-dark-okkano"
      "dark-discord"
      "dark-material-dracula"
      "dark-pop-ui"
      "darker-horizon"
      "darkmatter-theme"
      "day-shift"
      "decorative-stitch"
      "denix"
      "dogi"
      "dracula"
      "dram"
      "dream"
      "dune-theme"
      "eiffel-theme"
      "elderberry"
      "ember-theme"
      "emerald-night"
      "everforest"
      "everforest-theme"
      "evil-rabbit-theme"
      "exquisite"
      "eyecandy"
      "ezio-theme"
      "flat-theme"
      "fleet-themes"
      "fleeting-theme"
      "fleury"
      "flexoki-themes"
      "focus-theme"
      "forest-night"
      "frosted-theme"
      "gafelson"
      "gentle-dark"
      "github-classic"
      "github-copilot-theme"
      "github-dark-default"
      "github-monochrome-theme"
      "github-plus-theme"
      "github-theme"
      "glazier"
      "gleam-theme"
      "graphene"
      "green-monochrome-monitor-crt-phosphor"
      "grey-theme"
      "gruber-darker"
      "gruber-flavors"
      "gruvbox-baby"
      "gruvbox-crisp-themes"
      "gruvbox-ish"
      "gruvbox-material"
      "gruvchad"
      "hacker-night-vision"
      "hacker-theme"
      "haku-dark-theme"
      "halcyon"
      "hami-melon-theme"
      "hex-light-theme"
      "hivacruz-theme"
      "horizon"
      "horizon-extended"
      "hot-dog-stand"
      "ibm-5151"
      "iceberg"
      "iceicebergy"
      "indigo"
      "intellij-newui-theme"
      "ir-black"
      "jellybeans-vim"
      "jetbrains-darcula-theme-by-bronya0"
      "jetbrains-rider"
      "jetbrains-themes"
      "kanagawa-themes"
      "kanso"
      "kiro"
      "kiselevka"
      "ktrz-monokai"
      "kubesong"
      "leblackque"
      "lights-out"
      "lonely-planet"
      "lotus-theme"
      "lusch-theme"
      "lydia"
      "macos-classic"
      "malibu"
      "maple-theme"
      "marble"
      "mariana-theme"
      "marine-dark"
      "martianized"
      "material-dark"
      "material-theme"
      "matte-black"
      "mau"
      "maya"
      "melange"
      "mellow"
      "min-theme"
      "min-theme-plus"
      "mint-theme"
      "mnemonic"
      "modest-dark"
      "modus-themes"
      "molten-theme"
      "monokai-nebula"
      "monokai-night"
      "monokai-og"
      "monokai-reversed"
      "monokai-vibrant-amped"
      "monolith"
      "monosami"
      "monospace-theme"
      "moonlight"
      "mosel"
      "msun-dark"
      "muted"
      "nanowise"
      "napalm"
      "nebula-pulse"
      "neo-brutalism"
      "neon-cyberpunk"
      "neon-pulse-theme"
      "neosolarized"
      "neovim-default"
      "neutral-theme"
      "new-darcula"
      "night-owlz"
      "night-shift"
      "nightfox"
      "nightfox-m"
      "nixdorf-8870"
      "nobin-theme"
      "noctis-port"
      "noir-and-blanc-theme"
      "nord"
      "nordic-nvim-theme"
      "nordic-theme"
      "norrsken"
      "not-material-theme"
      "nstlgy-dark"
      "nuisance"
      "nvim-nightfox"
      "nyxvamp-theme"
      "oasis"
      "obsidian-sunset"
      "ocean-dark-motifs"
      "oceanic-next"
      "oh-lucy"
      "oldbook-theme"
      "one-black-theme"
      "one-dark-darkened"
      "one-dark-extended"
      "one-dark-flat"
      "one-dark-pro"
      "one-dark-pro-max"
      "one-dark-pro-monokai-darker"
      "one-hunter"
      "one-thing-theme"
      "onurb"
      "oolong"
      "oscura"
      "outrun"
      "oxocarbon"
      "palenight"
      "panda-theme"
      "papercolor"
      "paraiso"
      "penumbra"
      "penumbra-plus"
      "perfect-dusk"
      "phine-theme"
      "pinata-theme"
      "plato-themes"
      "poimandres"
      "polar-theme"
      "popping-and-locking"
      "purr"
      "quiet-light-theme"
      "quill"
      "railscast"
      "rainbow"
      "replicant"
      "retrofit-theme"
      "rich-vesper"
      "rose-pine-theme"
      "rosevin"
      "rust-rover-dark-theme"
      "s-dark-theme"
      "sequoia"
      "serendipity"
      "severance-theme"
      "shades-of-purple-theme"
      "short-giraffe-theme"
      "simple-darker"
      "siri"
      "sitruuna"
      "sl4y-theme"
      "slate"
      "smooth"
      "snazzy"
      "snow-fox-theme"
      "snowfall"
      "snowflake"
      "solarized"
      "solarized-fp"
      "sonokai"
      "spai-zero-theme"
      "spiceflow-theme"
      "srcery"
      "struct-theme"
      "sublime-mariana-theme"
      "subliminal-nightfall"
      "sumi-light"
      "sunset-drive"
      "supaglass"
      "supergreatmonokai"
      "syntax"
      "synthwave"
      "synthwave-alpha-theme"
      "t3-theme"
      "tailwind-theme"
      "tanuki"
      "terrible-theme"
      "the-best-theme"
      "the-dark-side"
      "theme-lince"
      "tm-twilight"
      "tokyo-night"
      "tomorrow-min-theme"
      "tomorrow-night-burns-theme"
      "tomorrow-theme"
      "tron-legacy"
      "tsar"
      "tsarcasm"
      "twilight"
      "ultimate-dark-neo"
      "umbralkai"
      "underground-theme"
      "unoflat"
      "v0-theme"
      "vague"
      "vapor-theme"
      "vercel-theme"
      "vesper"
      "vim-theme"
      "vintergata"
      "visual-assist-dark"
      "vitesse"
      "vitesse-theme-refined"
      "vscode-classic-theme"
      "vscode-dark-high-contrast"
      "vscode-dark-modern"
      "vscode-dark-plus"
      "vscode-dark-polished"
      "vscode-light-plus"
      "vscode-monokai-charcoal"
      "vue-theme"
      "vynora"
      "wakfu-theme"
      "warp-one-dark"
      "xcode-themes"
      "xy-zed"
      "yaka"
      "yamura"
      "yellowed"
      "yue-theme"
      "yugen"
      "zed-legacy-themes"
      "zedburn"
      "zedokai"
      "zedokai-darkest-machine"
      "zedrack-theme"
      "zedspace"
      "zedwaita"
      "zen"
      "zen-abyssal"
      "zero-trust-theme"
      "zoegi-theme"
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
        dark = "Palenight Theme";
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
        jdtls = {
          binary = {
            path = lib.getExe pkgs.jdt-language-server;
            # arguments = [ ];
            # env = { };
            ignore_system_version = true;
          };
        };

        kotlin-lsp = {
          binary = {
            path = lib.getExe pkgs.${namespace}.kotlin-lsp;
            arguments = [
              # Add your custom flags here
              # Example: "--flag-name" "value"
              "--stdio"
            ];
          };
        };

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
        path = cfg.nodePath;
        npm_path = cfg.npmPath;
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
        "Kotlin" = {
          language_servers = [
            "kotlin-lsp"
            "!kotlin-language-server"
          ];
        };
        "Java" = {
          language_servers = [
            "jdtls"
          ];
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
