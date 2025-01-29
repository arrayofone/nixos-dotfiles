{
  lib,
  pkgs,
  ...
}:
{
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;

      profiles.default = {
        enableUpdateCheck = true;
        enableExtensionUpdateCheck = true;
        userSettings = {
          "explorer.fileNesting.patterns.*.ts" = "\${capture}.js";
          "explorer.fileNesting.patterns.*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
          "explorer.fileNesting.patterns.*.jsx" = "\${capture}.js";
          "explorer.fileNesting.patterns.*.tsx" = "\${capture}.ts";
          "explorer.fileNesting.patterns.tsconfig.json" = "tsconfig.*.json";
          "explorer.fileNesting.patterns.package.json" =
            "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb";
          "explorer.fileNesting.patterns.*.sqlite" = "\${capture}.\${extname}-*";
          "explorer.fileNesting.patterns.*.db" = "\${capture}.\${extname}-*";
          "explorer.fileNesting.patterns.*.sqlite3" = "\${capture}.\${extname}-*";
          "explorer.fileNesting.patterns.*.db3" = "\${capture}.\${extname}-*";
          "explorer.fileNesting.patterns.*.sdb" = "\${capture}.\${extname}-*";
          "explorer.fileNesting.patterns.*.s3db" = "\${capture}.\${extname}-*";

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";

          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };

          "[json].editor.defaultFormatter" = "esbenp.prettier-vscode";

          "sqliteViewer.maxFileSize" = 1000;

          "editor.multiCursorLimit" = 100000;

          "files.autoSave" = "off";
          "files.eol" = "\n";
          "files.associations" = {
            "*.jsx" = "javascriptreact";
          };
          "files.insertFinalNewline" = true;

          "javascript.updateImportsOnFileMove.enabled" = "never";
          "[javascript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[javascriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          "typescript.updateImportsOnFileMove.enabled" = "never";
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          # golang
          "go" = {
            "buildTags" = "";
            "coverOnSingleTestFile" = true;
            "coverOnSingleTest" = true;
            "formatTool" = "gofmt";
            "autocompleteUnimportedPackages" = true;
            "lintTool" = "golangci-lint";
            "toolsManagement.autoUpdate" = true;
            "disableConcurrentTests" = true;

            "inlayHints" = {
              "assignVariableTypes" = true;
              "compositeLiteralFields" = true;
              "compositeLiteralTypes" = true;
              "constantValues" = true;
            };

            # "lintFlags" = [
            #   "--path-mode=abs"
            #   "--fast-only"
            # ];

            # "alternateTools" = {
            #   "customFormatter" = "golangci-lint";
            # };

            "formatFlags" = [
              "fmt"
              "--stdin"
            ];

            "testFlags" = [ ];
            "liveErrors" = {
              "enabled" = true;
              "delay" = 100;
            };
          };

          "[go]" = {
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.organizeImports" = "explicit";
            };
            # // Disable snippets; as they conflict with completion ranking.
            "editor.snippetSuggestions" = "none";
            "[go.mod]" = {
              "editor.codeActionsOnSave" = {
                "source.organizeImports" = "explicit";
              };
            };
          };

          "[go.mod]" = {
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.organizeImports" = "explicit";
            };
          };

          "gopls" = {
            "buildFlags" = [ ];
            # // Add parameter placeholders when completing a function.
            "usePlaceholders" = true;
            # // If true; enable additional analyses with staticcheck.
            # // Warning = This will significantly increase memory usage.
            "staticcheck" = false;
            "analyses" = {
              "fillstruct" = false;
            };
          };

          "[html]" = {
            "editor.defaultFormatter" = "vscode.html-language-features";
          };

          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };

          "[jsonc]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          "[graphql]" = {
            "editor.formatOnSave" = false;
          };

          "editor.suggestSelection" = "first";
          "editor.fontFamily" = "Intel One Mono";
          "editor.fontLigatures" = true;
          "editor.wordWrap" = "on";
          "editor.tabSize" = 2;
          "editor.unicodeHighlight.invisibleCharacters" = false;
          "editor.formatOnSave" = true;
          # "editor.fontSize" = 11;

          "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";

          "search.exclude" = {
            "**/node_modules" = false;
            "**/bower_components" = true;
            "**/*.code-search" = true;
          };

          "gitlens.hovers.currentLine.over" = "line";
          "diffEditor.ignoreTrimWhitespace" = true;

          "yaml.customTags" = [
            "!And"
            "!And sequence"
            "!If"
            "!If sequence"
            "!Not"
            "!Not sequence"
            "!Equals"
            "!Equals sequence"
            "!Or"
            "!Or sequence"
            "!FindInMap"
            "!FindInMap sequence"
            "!Base64"
            "!Join"
            "!Join sequence"
            "!Cidr"
            "!Ref"
            "!Sub"
            "!Sub sequence"
            "!GetAtt"
            "!GetAZs"
            "!ImportValue"
            "!ImportValue sequence"
            "!Select"
            "!Select sequence"
            "!Split"
            "!Split sequence"
          ];

          "[yaml]" = { };

          "json.schemas" = [ ];

          "git.autofetch" = true;
          "githubPullRequests.pullBranch" = "never";

          "eslint.workingDirectories" = [ { "mode" = "auto"; } ];
        };

        extensions = (
          with pkgs.vscode-extensions;
          [
            # asvetliakov.vscode-neovim

            bradlc.vscode-tailwindcss

            catppuccin.catppuccin-vsc

            dbaeumer.vscode-eslint

            github.vscode-pull-request-github

            eamodio.gitlens

            esbenp.prettier-vscode

            golang.go

            graphql.vscode-graphql
            #graphql.vscode-graphql-execution
            graphql.vscode-graphql-syntax

            hashicorp.terraform

            jnoortheen.nix-ide
            mathiasfrohlich.kotlin

            ms-azuretools.vscode-docker

            ms-kubernetes-tools.vscode-kubernetes-tools

            ms-vscode.makefile-tools

            vscjava.vscode-gradle
            vscjava.vscode-java-debug
            vscjava.vscode-java-dependency
            vscjava.vscode-java-test
            vscjava.vscode-maven

            redhat.java
            redhat.vscode-yaml

            # vscjava.vscode-java-pack
            zxh404.vscode-proto3
          ]
        );
      };
    };

    zed-editor = {
      enable = true;

      extraPackages = [ pkgs.nil ];
      installRemoteServer = true;
      package = pkgs.zed-editor;
      themes = { };
      userKeymaps = [ ];
      userTasks = [ ];

      ## This populates the userSettings "auto_install_extensions"
      extensions = [
        "assembly"
        "brainfuck"
        "catppuccin"
        "catppuccin-icons"
        "csv"
        "deno"
        "docker-compose"
        "dockerfile"
        "dracula"
        "dune-theme"
        "git-firefly"
        "github-dark-default"
        "github-theme"
        "golangci-lint"
        "graphql"
        "gruvbox-material"
        "helm"
        "html"
        "http"
        "ini"
        "java"
        "kotlin"
        "log"
        "material-dark"
        "macos-classic"
        "make"
        "material-theme"
        "material-icon-theme"
        "mermaid"
        "monospace-theme"
        "monospace-icon-theme"
        "nginx"
        "nix"
        "one-dark-pro"
        "perplexity"
        "proto"
        "sql"
        "tailwind-theme"
        "terraform"
        "the-dark-side"
        "tmux"
        "tokyo-night"
        "toml"
        "xml"
        "zig"
      ];

      ## everything inside of these brackets are Zed options.
      userSettings = {
        features = {
          edit_prediction_provider = "none";
        };

        assistant = {
          enabled = true;
          version = "2";
          default_open_ai_model = null;
          ### PROVIDER OPTIONS
          ### zed.dev models { claude-3-5-sonnet-latest } requires github connected
          ### anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest  } requires API_KEY
          ### copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
          default_model = {
            provider = "zed.dev";
            model = "claude-3-5-sonnet-latest";
          };

          #                inline_alternatives = [
          #                    {
          #                        provider = "copilot_chat";
          #                        model = "gpt-3.5-turbo";
          #                    }
          #                ];
        };

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

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        hour_format = "hour24";
        auto_update = false;
        terminal = {
          alternate_scroll = "off";
          blinking = "off";
          copy_on_select = false;
          dock = "bottom";
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
          env = {
            TERM = "ghostty";
          };
          font_family = "IntoneMono Nerd Font Mono";
          font_features = null;
          font_size = null;
          line_height = "comfortable";
          option_as_meta = false;
          button = false;
          shell = "system";
          #{
          #                    program = "zsh";
          #};
          toolbar = {
            title = true;
          };
          working_directory = "current_project_directory";
        };

        lsp = {
          # rust-analyzer = {
          #   binary = {
          #     path = lib.getExe pkgs.rust-analyzer;
          #     path_lookup = true;
          #   };
          # };
          nix = {
            binary = {
              path = lib.getExe pkgs.nil;
            };
          };
          protobuf-language-server = {
            binary = {
              path = lib.getExe pkgs.protols;
            };
          };
        };

        vim_mode = false;
        ## tell zed to use direnv and direnv can use a flake.nix enviroment.
        load_direnv = "shell_hook";
        base_keymap = "VSCode";
        theme = lib.mkDefault {
          mode = "system";
          light = "Tokyo Night Storm";
          dark = "Tokyo Night";
        };
        show_whitespaces = "boundary";
        ui_font_size = lib.mkDefault 12;
        buffer_font_size = lib.mkDefault 12;
      };
    };
  };
}
