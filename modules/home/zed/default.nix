# @gitian Zed editor configuration — declarative settings, extensions, keymaps, and LSP wiring.
# LSP binaries are resolved from nixpkgs (nixd, jdtls, protols, kotlin-lsp).
# Biome is configured as the primary formatter for JS/TS/JSON/CSS/GraphQL.
# See [[architecture]] for how this fits into the home-manager module tree.
{
  lib,
  namespace,
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
      "biome"
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
      active_pane_modifiers = {
        border_size = 0;
        inactive_opacity = 1;
      };
      agent = {
        default_model = {
          model = "claude-4-sonnet";
          provider = "anthropic";
        };
      };
      # agent_font_size = null;
      allow_rewrap = "in_comments";
      always_treat_brackets_as_autoclosed = false;
      auto_indent = true;
      auto_indent_on_paste = true;
      auto_install_extensions = {
        html = true;
      };
      auto_signature_help = false;
      auto_update = false;
      auto_update_extensions = { };
      autosave = "off";
      autoscroll_on_clicks = false;
      base_keymap = "VSCode";
      bottom_dock_layout = "contained";
      buffer_font_fallbacks = null;
      buffer_font_family = "IntoneMono Nerd Font Mono";
      buffer_font_features = null;
      buffer_font_size = 12;
      buffer_font_weight = 400;
      buffer_line_height = "comfortable";
      calls = {
        mute_on_join = false;
        share_on_join = false;
      };
      centered_layout = {
        left_padding = 0.2;
        right_padding = 0.2;
      };
      close_on_file_delete = false;
      # code_lens = "off";
      collaboration_panel = {
        button = false;
        default_width = 240;
        dock = "left";
      };
      colorize_brackets = false;
      completions = {
        lsp = true;
        lsp_fetch_timeout_ms = 0;
        lsp_insert_mode = "replace_suffix";
        words = "fallback";
        words_min_length = 3;
      };
      confirm_quit = false;
      current_line_highlight = "all";
      cursor_blink = true;
      cursor_shape = "bar";
      debugger = {
        button = true;
        dock = "bottom";
        save_breakpoints = true;
        stepping_granularity = "line";
      };
      diagnostics = {
        include_warnings = true;
        inline = {
          enabled = false;
          max_severity = null;
          min_column = 0;
          padding = 4;
          update_debounce_ms = 150;
        };
        # primary_only = false;
        # update_with_cursor = false;
        # use_rendered = false;
      };
      diagnostics_max_severity = null;
      # diff_view_style = "split";
      disable_ai = false;
      # document_folding_ranges = "off";
      # document_symbols = "off";
      double_click_in_multibuffer = "select";
      drag_and_drop_selection = {
        delay = 300;
        enabled = true;
      };
      drop_target_size = 0.2;
      edit_predictions = {
        disabled_globs = [
          "**/.env*"
          "**/*.pem"
          "**/*.key"
          "**/*.cert"
          "**/*.crt"
          "**/.dev.vars"
          "**/secrets.yml"
        ];
      };
      edit_predictions_disabled_in = [ ];
      enable_language_server = true;
      ensure_final_newline_on_save = true;
      excerpt_context_lines = 2;
      expand_excerpt_lines = 5;
      extend_comment_on_newline = true;
      # extend_list_on_newline = true;
      fast_scroll_sensitivity = 4;
      features = {
        edit_predictions = {
          provider = "none";
        };
      };
      file_finder = {
        file_icons = true;
        modal_max_width = "small";
        skip_focus_for_active_in_search = true;
      };
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/.jj"
        "**/.sl"
        "**/.repo"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
      ];
      file_scan_inclusions = [ ".env*" ];
      file_types = {
        "C" = [
          "*.c"
          "*.h"
        ];
        "C#" = [ "*.cs" ];
        "C++" = [
          "*.cpp"
          "*.cc"
          "*.cxx"
          "*.hpp"
          "*.hh"
          "*.hxx"
        ];
        "CSS" = [ "*.css" ];
        "Dart" = [ "*.dart" ];
        "Dockerfile" = [
          "Dockerfile*"
          "*.dockerfile"
        ];
        "Go" = [ "*.go" ];
        "GraphQL" = [
          "*.graphql"
          "*.gql"
        ];
        "HCL" = [ "*.hcl" ];
        "HTML" = [
          "*.html"
          "*.htm"
          "*.shtml"
          "*.xhtml"
        ];
        "Java" = [
          "*.java"
          "*.jav"
        ];
        "JavaScript" = [
          "*.js"
          "*.cjs"
          "*.mjs"
          "*.jsx"
        ];
        "JSONC" = [
          "**/.zed/**/*.json"
          "**/zed/**/*.json"
          "**/Zed/**/*.json"
          "**/.vscode/**/*.json"
          "tsconfig.json"
          "jsconfig.json"
        ];
        "Kotlin" = [
          "*.kt"
          "*.kts"
        ];
        "Lua" = [ "*.lua" ];
        "Markdown" = [
          "*.md"
          "*.markdown"
        ];
        "Nix" = [ "*.nix" ];
        "PHP" = [ "*.php" ];
        "Proto" = [ "*.proto" ];
        "Python" = [
          "*.py"
          "*.pyi"
          "SConstruct"
          "SConscript"
        ];
        "Ruby" = [
          "*.rb"
          "Rakefile"
          "Gemfile"
        ];
        "Rust" = [ "*.rs" ];
        "SCSS" = [ "*.scss" ];
        "Shell Script" = [
          ".env.*"
          "*.zsh"
          "*.bash"
          "*.sh"
          "APKBUILD"
          "PKGBUILD"
          "*.ebuild"
          "*.eclass"
          ".bashrc"
          ".bash_profile"
          ".zshrc"
          ".zprofile"
        ];
        "SQL" = [
          "*.sql"
          "*.ddl"
          "*.dml"
        ];
        "Swift" = [ "*.swift" ];
        "Terraform" = [
          "*.tf"
          "*.tfvars"
        ];
        "TOML" = [ "*.toml" ];
        "TypeScript" = [
          "*.ts"
          "*.cts"
          "*.mts"
          "*.tsx"
        ];
        "XML" = [
          "*.xml"
          "*.xsd"
          "*.xsl"
          "*.xslt"
        ];
        "YAML" = [
          "*.yml"
          "*.yaml"
        ];
        "Zig" = [ "*.zig" ];
      };
      format_on_save = "on";
      formatter = "auto";
      git = {
        branch_picker = {
          show_author_name = true;
        };
        git_gutter = "tracked_files";
        gutter_debounce = null;
        hunk_style = "staged_hollow";
        inline_blame = {
          delay_ms = 600;
          enabled = true;
          # min_column = 0;
          # padding = 0;
          # show_commit_summary = false;
        };
        # worktree_directory = "../worktrees";
      };
      git_hosting_providers = [ ];
      git_panel = {
        button = true;
        collapse_untracked_diff = false;
        default_width = 360;
        dock = "left";
        fallback_branch_name = "main";
        scrollbar = {
          show = null;
        };
        sort_by_path = false;
        status_style = "icon";
      };
      global_lsp_settings = {
        button = true;
        # notifications = {
        #   dismiss_timeout_ms = 5000;
        # };
        # request_timeout = 120;
      };
      go_to_definition_fallback = "find_all_references";
      # go_to_definition_scroll_strategy = "center";
      gutter = {
        breakpoints = true;
        folds = true;
        line_numbers = true;
        min_line_number_digits = 4;
        runnables = true;
      };
      hard_tabs = false;
      helix_mode = false;
      hide_mouse = "on_typing_and_movement";
      horizontal_scroll_margin = 5;
      hover_popover_delay = 300;
      hover_popover_enabled = true;
      # hover_popover_hiding_delay = 300;
      # hover_popover_sticky = true;
      icon_theme = {
        dark = "Zed (Default)";
        light = "Zed (Default)";
        mode = "system";
      };
      image_viewer = {
        unit = "binary";
      };
      indent_guides = {
        active_line_width = 1;
        background_coloring = "disabled";
        coloring = "fixed";
        enabled = true;
        line_width = 1;
      };
      # indent_list_on_tab = true;
      inlay_hints = {
        edit_debounce_ms = 700;
        enabled = false;
        scroll_debounce_ms = 50;
        show_background = false;
        show_other_hints = true;
        show_parameter_hints = true;
        show_type_hints = true;
        toggle_on_modifiers_press = null;
      };
      inline_code_actions = true;
      # instrumentation = {
      #   performance_profiler = {
      #     enabled = false;
      #   };
      # };
      journal = {
        hour_format = "hour12";
        path = "~";
      };
      jsx_tag_auto_close = {
        enabled = true;
      };
      language_models = {
        anthropic = {
          api_url = "https://api.anthropic.com";
        };
        google = {
          api_url = "https://generativelanguage.googleapis.com";
        };
        ollama = {
          api_url = "http://localhost:11434";
        };
        openai = {
          api_url = "https://api.openai.com/v1";
        };
      };
      languages = {
        CSS = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        Go = {
          hard_tabs = true;
          tab_size = 4;
        };
        GraphQL = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        Java = {
          language_servers = [ "jdtls" ];
        };
        JavaScript = {
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
          enable_language_server = true;
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          hard_tabs = false;
          language_servers = [
            "!eslint"
            "biome"
          ];
          tab_size = 2;
        };
        JSON = {
          code_actions_on_format = {
            "source.fixAll.biome" = true;
          };
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          hard_tabs = false;
          tab_size = 2;
        };
        JSONC = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        Kotlin = {
          language_servers = [
            "kotlin-lsp"
            "!kotlin-language-server"
          ];
        };
        Nix = {
          hard_tabs = true;
          language_servers = [
            "nixd"
            "!nil"
          ];
          tab_size = 4;
        };
        TSX = {
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        TypeScript = {
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
          enable_language_server = true;
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          hard_tabs = false;
          language_servers = [
            "!eslint"
            "!graphql"
            "!deno"
            "!typescript-language-server"
            "biome"
            "..."
          ];
          tab_size = 2;
        };
      };
      # line_ending = "detect";
      line_indicator_format = "short";
      linked_edits = true;
      load_direnv = "shell_hook";
      lsp = {
        biome = {
          settings = {
            require_config_file = true;
          };
        };
        deno = {
          settings = {
            deno = {
              enable = true;
            };
          };
        };
        jdtls = {
          binary = {
            ignore_system_version = true;
            path = lib.getExe pkgs.jdt-language-server;
          };
        };
        # kotlin-lsp = {
        #   binary = {
        #     path = lib.getExe pkgs.${namespace}.kotlin-lsp;
        #     arguments = [ "--stdio" ];
        #   };
        # };
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
      lsp_document_colors = "border";
      lsp_highlight_debounce = 75;
      max_tabs = null;
      middle_click_paste = true;
      minimap = {
        current_line_highlight = "line";
        show = "always";
        thumb = "always";
        thumb_border = "left_open";
      };
      # mouse_wheel_zoom = false;
      multi_cursor_modifier = "alt";
      node = {
        ignore_system_version = true;
        npm_path = lib.getExe' pkgs.nodejs_22 "npm";
        path = lib.getExe pkgs.nodejs_22;
      };
      notification_panel = {
        button = true;
        dock = "bottom";
      };
      on_last_window_closed = "platform_default";
      outline_panel = {
        auto_fold_dirs = true;
        auto_reveal_entries = true;
        button = true;
        default_width = 300;
        dock = "right";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        indent_guides = {
          show = "always";
        };
        indent_size = 20;
        scrollbar = {
          show = null;
        };
      };
      pane_split_direction_horizontal = "up";
      pane_split_direction_vertical = "left";
      preferred_line_length = 80;
      preview_tabs = {
        enable_keep_preview_on_code_navigation = false;
        enable_preview_file_from_code_navigation = true;
        enable_preview_from_file_finder = true;
        enable_preview_from_multibuffer = true;
        enable_preview_from_project_panel = true;
        enable_preview_multibuffer_from_code_navigation = false;
        enabled = true;
      };
      private_files = [
        "**/.env*"
        "**/*.pem"
        "**/*.key"
        "**/*.cert"
        "**/*.crt"
        "**/secrets.yml"
      ];
      profiles = { };
      project_panel = {
        auto_fold_dirs = true;
        auto_open = {
          on_create = true;
          on_drop = true;
          on_paste = true;
        };
        auto_reveal_entries = true;
        button = true;
        default_width = 240;
        dock = "left";
        drag_and_drop = true;
        entry_spacing = "comfortable";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        hide_hidden = false;
        hide_root = false;
        indent_guides = {
          show = "always";
        };
        indent_size = 20;
        scrollbar = {
          show = null;
        };
        show_diagnostics = "all";
        sort_mode = "directories_first";
        starts_open = true;
        sticky_scroll = true;
      };
      # projects_online_by_default = true;
      proxy = null;
      read_ssh_config = true;
      redact_private_values = false;
      relative_line_numbers = "disabled";
      remove_trailing_whitespace_on_save = true;
      repl = {
        max_columns = 128;
        max_lines = 32;
      };
      resize_all_panels_in_dock = [ "left" ];
      restore_on_file_reopen = true;
      restore_on_startup = "last_session";
      rounded_selection = true;
      scroll_beyond_last_line = "one_page";
      scroll_sensitivity = 1;
      scrollbar = {
        axes = {
          horizontal = true;
          vertical = true;
        };
        cursors = true;
        diagnostics = "all";
        git_diff = true;
        search_results = true;
        selected_symbol = true;
        selected_text = true;
        show = "auto";
      };
      search = {
        button = true;
        case_sensitive = false;
        center_on_match = false;
        include_ignored = false;
        regex = false;
        whole_word = false;
      };
      search_wrap = true;
      seed_search_query_from_cursor = "always";
      selection_highlight = true;
      # semantic_tokens = "off";
      session = {
        restore_unsaved_buffers = true;
        trust_all_worktrees = false;
      };
      show_call_status_icon = true;
      show_completion_documentation = true;
      show_completions_on_input = true;
      show_edit_predictions = true;
      show_signature_help_after_edits = false;
      show_whitespaces = "boundary";
      show_wrap_guides = true;
      snippet_sort_order = "inline";
      soft_wrap = "none";
      status_bar = {
        # active_encoding_button = "non_utf8";
        active_language_button = true;
        cursor_position_button = true;
        line_endings_button = false;
      };
      tab_bar = {
        show = true;
        show_nav_history_buttons = true;
        show_tab_bar_buttons = true;
      };
      tab_size = 2;
      tabs = {
        activate_on_close = "history";
        close_position = "right";
        file_icons = false;
        git_status = false;
        show_close_button = "hover";
        show_diagnostics = "off";
      };
      tasks = {
        enabled = true;
        prefer_lsp = false;
        variables = { };
      };
      telemetry = {
        diagnostics = true;
        metrics = true;
      };
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        button = false;
        copy_on_select = false;
        default_height = 320;
        default_width = 640;
        detect_venv = {
          on = {
            activate_script = "default";
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
          };
        };
        dock = "bottom";
        env = {
          TERM = "ghostty";
        };
        font_family = "IntoneMono Nerd Font Mono";
        font_features = null;
        font_size = null;
        keep_selection_on_copy = true;
        line_height = "comfortable";
        minimum_contrast = 45;
        option_as_meta = false;
        path_hyperlink_regexes = [
          "File \"(?<path>[^\"]+)\", line (?<line>[0-9]+)"
          "(?x)"
          "# optionally starts with 0-2 opening prefix symbols"
          "[({\\[<]{0,2}"
          "# which may be followed by an opening quote"
          "(?<quote>[\"'`])?"
          "# `path` is the shortest sequence of any non-space character"
          "(?<link>(?<path>[^ ]+?"
          "    # which may end with a line and optionally a column,"
          "    (?<line_column>:+[0-9]+(:[0-9]+)?|:?\\([0-9]+([,:][0-9]+)?\\))?"
          "))"
          "# which must be followed by a matching quote"
          "(?(<quote>)\\k<quote>)"
          "# and optionally a single closing symbol"
          "[)}\\]>]?"
          "# if line/column matched, may be followed by a description"
          "(?(<line_column>):[^ 0-9][^ ]*)?"
          "# which may be followed by trailing punctuation"
          "[.,:)}\\]>]*"
          "# and always includes trailing whitespace or end of line"
          "([ ]+|$)"
        ];
        path_hyperlink_timeout_ms = 1;
        scroll_multiplier = 3;
        scrollbar = {
          show = null;
        };
        shell = "system";
        toolbar = {
          breadcrumbs = false;
        };
        working_directory = "current_project_directory";
      };
      # text_rendering_mode = "platform_default";
      theme = {
        dark = "Palenight Theme";
        light = "Tokyo Night Storm";
        mode = "system";
      };
      theme_overrides = {
        "Palenight Theme" = {
          # Error diagnostics - bright red tones for visibility
          "error" = "#ff5370";
          "error.background" = "#ff537020";
          "error.border" = "#ff5370";

          # Warning diagnostics - amber/orange tones
          "warning" = "#ffcb6b";
          "warning.background" = "#ffcb6b20";
          "warning.border" = "#ffcb6b";

          # Info diagnostics - blue tones
          "info" = "#82aaff";
          "info.background" = "#82aaff20";
          "info.border" = "#82aaff";

          # Hint diagnostics - subtle cyan
          "hint" = "#89ddff";
          "hint.background" = "#89ddff15";
          "hint.border" = "#89ddff";
        };
      };
      title_bar = {
        show_branch_icon = false;
        show_branch_name = true;
        show_menus = false;
        show_onboarding_banner = true;
        show_project_items = true;
        show_sign_in = true;
        show_user_menu = true;
        show_user_picture = true;
      };
      toolbar = {
        agent_review = true;
        breadcrumbs = true;
        code_actions = false;
        quick_actions = true;
        selections_menu = true;
      };
      ui_font_fallbacks = null;
      ui_font_family = "IntoneMono Nerd Font Mono";
      ui_font_features = {
        calt = false;
      };
      ui_font_size = 12;
      ui_font_weight = 400;
      unnecessary_code_fade = 0.3;
      use_auto_surround = true;
      use_autoclose = true;
      use_on_type_format = true;
      use_smartcase_search = false;
      use_system_path_prompts = true;
      use_system_prompts = true;
      use_system_window_tabs = false;
      vertical_scroll_margin = 3;
      vim_mode = false;
      when_closing_with_no_tabs = "platform_default";
      whitespace_map = {
        space = "•";
        tab = "→";
      };
      wrap_guides = [ ];
    };
  };
}
