{
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
          "nix.serverPath" = "nixd";

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
  };
}
