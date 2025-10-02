{
  config,
  pkgs,
  ...
}:
{
  home.shell.enableZshIntegration = true;

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        # -------------------- Global Settings --------------------

        # The format of the prompt
        format = "$os$shell$nix_shell$username$hostname$directory$git_branch$git_status$git_commit$aws$gcloud$fill$golang$nodejs$python$java$c$lua$kotlin$dart$zig$deno$bun$terraform$time$battery$line_break$git_state$character";

        # The format of the right-side prompt
        right_format = "$cmd_duration$status";

        # Timeout for starship to scan files (in milliseconds)
        scan_timeout = 50;

        # Timeout for commands executed by starship (in milliseconds)
        command_timeout = 1300;

        # Inserts a blank line between shell prompts
        add_newline = true;

        # Sets which color palette from `palettes` to use
        # palette = "";

        # Follows symlinks to check if they're directories
        follow_symlinks = true;

        # -------------------- Modules --------------------

        aws = {
          format = "[[ $symbol ($profile )($region) ](fg:#ff9900 bg:#212736)]($style) ";
          symbol = "☁️ ";
          region_aliases = { };
          profile_aliases = { };
          style = "bold yellow";
          expiration_symbol = "X";
          disabled = false;
          force_display = false;
        };

        azure = {
          format = "[[ $symbol ($subscription) ](fg:#0078d4 bg:#212736)]($style) ";
          symbol = "󰠅 ";
          style = "bg:#212736";
          disabled = true;
          subscription_aliases = { };
        };

        battery = {
          full_symbol = "󰁹 ";
          charging_symbol = "󰂄 ";
          discharging_symbol = "󰂃 ";
          unknown_symbol = "󰁽 ";
          empty_symbol = "󰂎 ";
          format = "[$symbol$percentage]($style) ";
          disabled = false;
          display = [
            {
              threshold = 10;
              style = "bold red";
            }
            {
              threshold = 30;
              style = "bold yellow";
            }
          ];
        };

        buf = {
          format = "with [$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🐃 ";
          detect_extensions = [ ];
          detect_files = [
            "buf.yaml"
            "buf.gen.yaml"
            "buf.work.yaml"
          ];
          detect_folders = [ ];
          style = "bold blue";
          disabled = false;
        };

        bun = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🥟 ";
          detect_extensions = [ ];
          detect_files = [
            "bun.lock"
            "bun.lockb"
            "bunfig.toml"
          ];
          detect_folders = [ ];
          style = "bold red";
          disabled = false;
        };

        c = {
          format = "[$symbol($version(-$name) )]($style)";
          version_format = "v\${raw}";
          symbol = "C ";
          detect_extensions = [
            "c"
            "h"
          ];
          detect_files = [ ];
          detect_folders = [ ];
          commands = [
            [
              "cc"
              "--version"
            ]
            [
              "gcc"
              "--version"
            ]
            [
              "clang"
              "--version"
            ]
          ];
          style = "bold 149";
          disabled = false;
        };

        character = {
          format = "$symbol ";
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold green)";
          vimcmd_replace_one_symbol = "[❮](bold purple)";
          vimcmd_replace_symbol = "[❮](bold purple)";
          vimcmd_visual_symbol = "[❮](bold yellow)";
          disabled = false;
        };

        cmake = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "📐";
          detect_extensions = [ ];
          detect_files = [
            "CMakeLists.txt"
            "CMakeCache.txt"
          ];
          detect_folders = [ ];
          style = "bold blue";
          disabled = false;
        };

        cmd_duration = {
          min_time = 1000;
          show_milliseconds = false;
          format = "[$duration]($style)";
          style = "bold #f9e2af";
          disabled = false;
          show_notifications = false;
          min_time_to_notify = 45000;
        };

        cobol = {
          symbol = "⚙️ ";
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          style = "bold blue";
          detect_extensions = [
            "cbl"
            "cob"
            "CBL"
            "COB"
          ];
          detect_files = [ ];
          detect_folders = [ ];
          disabled = false;
        };

        conda = {
          truncation_length = 1;
          symbol = "🅒 ";
          style = "bold green";
          format = "[$symbol$environment]($style) ";
          ignore_base = true;
          detect_env_vars = [ "!PIXI_ENVIRONMENT_NAME" ];
          disabled = false;
        };

        container = {
          symbol = "⬢";
          style = "bold red dimmed";
          format = "[$symbol \[$name\]]($style) ";
          disabled = false;
        };

        cpp = {
          format = "[$symbol($version(-$name) )]($style)";
          version_format = "v\${raw}";
          symbol = "C++ ";
          detect_extensions = [
            "cpp"
            "cc"
            "cxx"
            "c++"
            "hpp"
            "hh"
            "hxx"
            "h++"
            "tcc"
          ];
          detect_files = [ ];
          detect_folders = [ ];
          commands = [
            [
              "c++"
              "--version"
            ]
            [
              "g++"
              "--version"
            ]
            [
              "clang++"
              "--version"
            ]
          ];
          style = "bold 149";
          disabled = true;
        };

        crystal = {
          symbol = "🔮 ";
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          style = "bold red";
          detect_extensions = [ "cr" ];
          detect_files = [ "shard.yml" ];
          detect_folders = [ ];
          disabled = false;
        };

        daml = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "Λ ";
          style = "bold cyan";
          detect_extensions = [ ];
          detect_files = [ "daml.yaml" ];
          detect_folders = [ ];
          disabled = false;
        };

        dart = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🎯 ";
          detect_extensions = [ "dart" ];
          detect_files = [
            "pubspec.yaml"
            "pubspec.yml"
            "pubspec.lock"
          ];
          detect_folders = [ ".dart_tool" ];
          style = "bold blue";
          disabled = false;
        };

        deno = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🦕 ";
          detect_extensions = [ ];
          detect_files = [
            "deno.json"
            "deno.jsonc"
            "deno.lock"
            "mod.ts"
            "mod.js"
            "deps.ts"
            "deps.js"
          ];
          detect_folders = [ ];
          style = "green bold";
          disabled = false;
        };

        directory = {
          truncation_length = 3;
          truncate_to_repo = false;
          format = "[$path]($style)[$read_only]($read_only_style) ";
          style = "bold cyan";
          disabled = false;
          read_only = "🔒";
          read_only_style = "red";
          truncation_symbol = "";
          repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
          home_symbol = "~";
          use_os_path_sep = true;
          substitutions = { };
          fish_style_pwd_dir_length = 0;
          use_logical_path = true;
        };

        direnv = {
          format = "[$symbol$loaded/$allowed]($style) ";
          symbol = "direnv ";
          style = "bold orange";
          disabled = true;
          detect_extensions = [ ];
          detect_files = [ ".envrc" ];
          detect_folders = [ ];
          detect_env_vars = [ "DIRENV_FILE" ];
          allowed_msg = "allowed";
          not_allowed_msg = "not allowed";
          denied_msg = "denied";
          loaded_msg = "loaded";
          unloaded_msg = "not loaded";
        };

        docker_context = {
          format = "[$symbol$context]($style) ";
          symbol = "🐳 ";
          only_with_files = true;
          detect_extensions = [ ];
          detect_files = [
            "docker-compose.yml"
            "docker-compose.yaml"
            "Dockerfile"
          ];
          detect_folders = [ ];
          style = "blue bold";
          disabled = false;
        };

        dotnet = {
          format = "[$symbol($version )(🎯 $tfm )]($style)";
          version_format = "v\${raw}";
          symbol = ".NET ";
          heuristic = true;
          detect_extensions = [
            "csproj"
            "fsproj"
            "xproj"
          ];
          detect_files = [
            "global.json"
            "project.json"
            "Directory.Build.props"
            "Directory.Build.targets"
            "Packages.props"
          ];
          detect_folders = [ ];
          style = "bold blue";
          disabled = false;
        };

        elixir = {
          format = "[$symbol($version \(OTP $otp_version\) )]($style)";
          version_format = "v\${raw}";
          symbol = "💧 ";
          detect_extensions = [ ];
          detect_files = [ "mix.exs" ];
          detect_folders = [ ];
          style = "bold purple";
          disabled = false;
        };

        elm = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🌳 ";
          detect_extensions = [ "elm" ];
          detect_files = [
            "elm.json"
            "elm-package.json"
            ".elm-version"
          ];
          detect_folders = [ "elm-stuff" ];
          style = "cyan bold";
          disabled = false;
        };

        erlang = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "";
          style = "bold red";
          detect_extensions = [ ];
          detect_files = [
            "rebar.config"
            "elang.mk"
          ];
          detect_folders = [ ];
          disabled = false;
        };

        fennel = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🧅 ";
          style = "bold green";
          detect_extensions = [ "fnl" ];
          detect_files = [ ];
          detect_folders = [ ];
          disabled = false;
        };

        fill = {
          symbol = "━";
          style = "bold #45475a";
          disabled = false;
        };

        fossil_branch = {
          format = "[$symbol$branch]($style) ";
          symbol = "";
          style = "bold purple";
          truncation_length = 9223372036854775807;
          truncation_symbol = "…";
          disabled = true;
        };

        fossil_metrics = {
          format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
          added_style = "bold green";
          deleted_style = "bold red";
          only_nonzero_diffs = true;
          disabled = true;
        };

        gcloud = {
          format = "[$symbol$account(@$project)]($style) ";
          symbol = "☁️ ";
          region_aliases = { };
          project_aliases = { };
          detect_env_vars = [ ];
          style = "bold blue";
          disabled = false;
        };

        git_branch = {
          always_show_remote = false;
          format = "[$symbol$branch(:$remote_branch)]($style) ";
          symbol = " ";
          style = "bold purple";
          truncation_length = 9223372036854775807;
          truncation_symbol = "…";
          only_attached = false;
          ignore_branches = [ ];
          disabled = false;
        };

        git_commit = {
          commit_hash_length = 7;
          format = "[\($hash$tag\)]($style) ";
          style = "bold green";
          only_detached = true;
          tag_disabled = true;
          tag_max_candidates = 0;
          tag_symbol = " 🏷 ";
          disabled = false;
        };

        git_metrics = {
          added_style = "bold green";
          deleted_style = "bold red";
          only_nonzero_diffs = true;
          format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
          disabled = true;
          ignore_submodules = false;
        };

        git_state = {
          rebase = "REBASING";
          merge = "MERGING";
          revert = "REVERTING";
          cherry_pick = "CHERRY-PICKING";
          bisect = "BISECTING";
          am = "AM";
          am_or_rebase = "AM/REBASE";
          style = "bold yellow";
          format = "\([$state( $progress_current/$progress_total)]($style)\) ";
          disabled = false;
        };

        git_status = {
          format = "([$all_status$ahead_behind]($style)) ";
          conflicted = "=";
          ahead = "⇡";
          behind = "⇣";
          diverged = "⇕⇡$ahead_count⇣$behind_count";
          up_to_date = "";
          untracked = "?";
          # stashed = "$";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "✘";
          typechanged = "";
          style = "bold red";
          ignore_submodules = false;
          disabled = false;
          use_git_executable = false;
        };

        gleam = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "⭐ ";
          detect_extensions = [ "gleam" ];
          detect_files = [ "gleam.toml" ];
          style = "bold #FFAFF3";
          disabled = false;
        };

        golang = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🐹 ";
          detect_extensions = [ "go" ];
          detect_files = [
            "go.mod"
            "go.sum"
            "go.work"
            "glide.yaml"
            "Gopkg.yml"
            "Gopkg.lock"
            ".go-version"
          ];
          detect_folders = [ "Godeps" ];
          style = "bold cyan";
          not_capable_style = "bold red";
          disabled = false;
        };

        gradle = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🅶 ";
          detect_extensions = [
            "gradle"
            "gradle.kts"
          ];
          detect_files = [ ];
          detect_folders = [ "gradle" ];
          style = "bold bright-cyan";
          disabled = false;
          recursive = false;
        };

        guix_shell = {
          format = "[$symbol]($style) ";
          symbol = "🐃 ";
          style = "yellow bold";
          disabled = false;
        };

        haskell = {
          format = "[$symbol($version )]($style)";
          symbol = "λ ";
          detect_extensions = [
            "hs"
            "cabal"
            "hs-boot"
          ];
          detect_files = [
            "stack.yaml"
            "cabal.project"
          ];
          detect_folders = [ ];
          style = "bold purple";
          disabled = false;
        };

        haxe = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          detect_extensions = [
            "hx"
            "hxml"
          ];
          detect_files = [
            "project.xml"
            "Project.xml"
            "application.xml"
            "haxelib.json"
            "hxformat.json"
            ".haxerc"
          ];
          detect_folders = [
            ".haxelib"
            "haxe_libraries"
          ];
          symbol = "⌘ ";
          style = "bold fg:202";
          disabled = false;
        };

        helm = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          detect_extensions = [ ];
          detect_files = [
            "helmfile.yaml"
            "Chart.yaml"
          ];
          detect_folders = [ ];
          symbol = "⎈ ";
          style = "bold white";
          disabled = false;
        };

        hg_branch = {
          symbol = "";
          style = "bold purple";
          format = "[$symbol$branch(:$topic)]($style) ";
          truncation_length = 9223372036854775807;
          truncation_symbol = "…";
          disabled = true;
        };

        hostname = {
          ssh_only = false;
          ssh_symbol = "";
          trim_at = ".";
          detect_env_vars = [ ];
          format = "[$hostname$ssh_symbol]($style) ";
          style = "bold dimmed green";
          disabled = false;
          aliases = { };
        };

        java = {
          format = "[\${symbol}(\${version} )]($style)";
          version_format = "v\${raw}";
          detect_extensions = [
            "java"
            "class"
            "gradle"
            "jar"
            "cljs"
            "cljc"
          ];
          detect_files = [
            "pom.xml"
            "build.gradle.kts"
            "build.sbt"
            ".java-version"
            "deps.edn"
            "project.clj"
            "build.boot"
            ".sdkmanrc"
          ];
          detect_folders = [ ];
          symbol = "☕ ";
          style = "red dimmed";
          disabled = false;
        };

        jobs = {
          symbol_threshold = 1;
          number_threshold = 1;
          format = "[$symbol$number]($style) ";
          symbol = "✦";
          style = "bold blue";
          disabled = false;
        };

        julia = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          detect_extensions = [ "jl" ];
          detect_files = [
            "Project.toml"
            "Manifest.toml"
          ];
          detect_folders = [ ];
          symbol = "ஃ ";
          style = "bold purple";
          disabled = false;
        };

        kotlin = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          detect_extensions = [
            "kt"
            "kts"
          ];
          detect_files = [ ];
          detect_folders = [ ];
          symbol = "🅺 ";
          style = "bold blue";
          kotlin_binary = "kotlin";
          disabled = false;
        };

        kubernetes = {
          symbol = "☸ ";
          format = "[$symbol$context( \($namespace\))]($style) in ";
          style = "cyan bold";
          detect_extensions = [ ];
          detect_files = [ ];
          detect_folders = [ ];
          detect_env_vars = [ ];
          contexts = [ ];
          disabled = false;
        };

        line_break = {
          disabled = false;
        };

        localip = {
          ssh_only = true;
          format = "[$localipv4]($style) ";
          style = "bold yellow";
          disabled = true;
        };

        lua = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🌙 ";
          detect_extensions = [ "lua" ];
          detect_files = [ ".lua-version" ];
          detect_folders = [ "lua" ];
          style = "bold blue";
          lua_binary = "lua";
          disabled = false;
        };

        memory_usage = {
          threshold = 75;
          format = "$symbol [\${ram}( | \${swap})]($style) ";
          symbol = "🐏";
          style = "bold dimmed white";
          disabled = true;
        };

        meson = {
          truncation_length = 4294967295;
          truncation_symbol = "…";
          format = "[$symbol$project]($style) ";
          symbol = "⬢ ";
          style = "blue bold";
          disabled = false;
        };

        mise = {
          symbol = "mise ";
          style = "bold purple";
          format = "[$symbol$health]($style) ";
          healthy_symbol = "healthy";
          unhealthy_symbol = "unhealthy";
          disabled = true;
        };

        mojo = {
          format = "with [$symbol($version )]($style)";
          symbol = "🔥 ";
          style = "bold 208";
          disabled = false;
          detect_extensions = [
            "mojo"
            "🔥"
          ];
          detect_files = [ ];
          detect_folders = [ ];
        };

        nats = {
          symbol = "✉️ ";
          style = "bold purple";
          format = "[$symbol$name]($style)";
          disabled = false;
        };

        netns = {
          format = "[$symbol \[$name\]]($style)";
          symbol = "🛜 ";
          style = "blue bold dimmed";
          disabled = false;
        };

        nim = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "👑 ";
          detect_extensions = [
            "nim"
            "nims"
            "nimble"
          ];
          detect_files = [ "nim.cfg" ];
          detect_folders = [ ];
          style = "bold yellow";
          disabled = false;
        };

        nix_shell = {
          format = "[$symbol$state( \($name\))]($style) ";
          symbol = "❄️ ";
          style = "bold blue";
          impure_msg = "impure";
          pure_msg = "pure";
          unknown_msg = "";
          disabled = false;
          heuristic = false;
        };

        nodejs = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "";
          detect_extensions = [
            "js"
            "mjs"
            "cjs"
            "ts"
            "mts"
            "cts"
          ];
          detect_files = [
            "package.json"
            ".node-version"
            ".nvmrc"
          ];
          detect_folders = [ "node_modules" ];
          style = "bold green";
          disabled = false;
          not_capable_style = "bold red";
        };

        ocaml = {
          format = "[$symbol($version )(\($switch_indicator$switch_name\) )]($style)";
          version_format = "v\${raw}";
          symbol = "🐫 ";
          global_switch_indicator = "";
          local_switch_indicator = "*";
          detect_extensions = [
            "opam"
            "ml"
            "mli"
            "re"
            "rei"
          ];
          detect_files = [
            "dune"
            "dune-project"
            "jbuild"
            "jbuild-ignore"
            ".merlin"
          ];
          detect_folders = [
            "_opam"
            "esy.lock"
          ];
          style = "bold yellow";
          disabled = false;
        };

        odin = {
          format = "[$symbol($version )]($style)";
          show_commit = false;
          symbol = "Ø ";
          style = "bold bright-blue";
          disabled = false;
          detect_extensions = [ "odin" ];
          detect_files = [ ];
          detect_folders = [ ];
        };

        opa = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🪖 ";
          detect_extensions = [ "rego" ];
          detect_files = [ ];
          detect_folders = [ ];
          style = "bold blue";
          disabled = false;
        };

        openstack = {
          format = "[$symbol$cloud(\($project\))]($style) ";
          symbol = "☁️ ";
          style = "bold yellow";
          disabled = false;
        };

        os = {
          format = "[$symbol]($style)";
          style = "bold white";
          disabled = false;
          symbols = {
            AIX = "➿ ";
            Alpaquita = "🔔 ";
            AlmaLinux = "💠 ";
            Alpine = "🏔️ ";
            Amazon = "🙂 ";
            Android = "🤖 ";
            Arch = "🎗️ ";
            Artix = "🎗️ ";
            Bluefin = "🐟 ";
            CachyOS = "🎗️ ";
            CentOS = "💠 ";
            Debian = "🌀 ";
            DragonFly = "🐉 ";
            Emscripten = "🔗 ";
            EndeavourOS = "🚀 ";
            Fedora = "🎩 ";
            FreeBSD = "😈 ";
            Garuda = "🦅 ";
            Gentoo = "🗜️ ";
            HardenedBSD = "🛡️ ";
            Illumos = "🐦 ";
            Kali = "🐉 ";
            Linux = "🐧 ";
            Mabox = "📦 ";
            Macos = "🍎 ";
            Manjaro = "🥭 ";
            Mariner = "🌊 ";
            MidnightBSD = "🌘 ";
            Mint = "🌿 ";
            NetBSD = "🚩 ";
            NixOS = "❄️ ";
            Nobara = "🎩 ";
            OpenBSD = "🐡 ";
            OpenCloudOS = "☁️ ";
            openEuler = "🦉 ";
            openSUSE = "🦎 ";
            OracleLinux = "🦴 ";
            Pop = "🍭 ";
            Raspbian = "🍓 ";
            Redhat = "🎩 ";
            RedHatEnterprise = "🎩 ";
            RockyLinux = "💠 ";
            Redox = "🧪 ";
            Solus = "⛵ ";
            SUSE = "🦎 ";
            Ubuntu = "🎯 ";
            Ultramarine = "🔷 ";
            Unknown = "❓ ";
            Uos = "🐲 ";
            Void = "  ";
            Windows = "🪟 ";
          };
        };

        package = {
          format = "[$symbol$version]($style) ";
          symbol = "📦 ";
          version_format = "v\${raw}";
          style = "bold 208";
          display_private = false;
          disabled = false;
        };

        perl = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🐪 ";
          detect_extensions = [
            "pl"
            "pm"
            "pod"
          ];
          detect_files = [
            "Makefile.PL"
            "Build.PL"
            "cpanfile"
            "cpanfile.snapshot"
            "META.json"
            "META.yml"
            ".perl-version"
          ];
          detect_folders = [ ];
          style = "bold 149";
          disabled = false;
        };

        php = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🐘 ";
          detect_extensions = [ "php" ];
          detect_files = [
            "composer.json"
            ".php-version"
          ];
          detect_folders = [ ];
          style = "147 bold";
          disabled = false;
        };

        pijul_channel = {
          symbol = "";
          style = "bold purple";
          format = "[$symbol$channel]($style) ";
          truncation_length = 9223372036854775807;
          truncation_symbol = "…";
          disabled = true;
        };

        pixi = {
          format = "[$symbol($version )(\($environment\) )]($style)";
          version_format = "v\${raw}";
          symbol = "🧚 ";
          style = "yellow bold";
          show_default_environment = true;
          pixi_binary = [ "pixi" ];
          detect_extensions = [ ];
          detect_files = [ "pixi.toml" ];
          detect_folders = [ ".pixi" ];
          disabled = false;
        };

        pulumi = {
          format = "[$symbol($username@)$stack]($style) ";
          version_format = "v\${raw}";
          symbol = "";
          style = "bold 5";
          search_upwards = true;
          disabled = false;
        };

        purescript = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "<=> ";
          detect_extensions = [ "purs" ];
          detect_files = [
            "spago.dhall"
            "spago.yaml"
            "spago.lock"
          ];
          detect_folders = [ ];
          style = "bold white";
          disabled = false;
        };

        python = {
          format = "[\${symbol}\${pyenv_prefix}(\${version} )(\(\$virtualenv\) )]($style)";
          version_format = "v\${raw}";
          symbol = "🐍 ";
          style = "yellow bold";
          pyenv_version_name = false;
          pyenv_prefix = "pyenv ";
          python_binary = [
            "python"
            "python3"
            "python2"
          ];
          detect_extensions = [
            "py"
            "ipynb"
          ];
          detect_files = [
            ".python-version"
            "Pipfile"
            "__init__.py"
            "pyproject.toml"
            "requirements.txt"
            "setup.py"
            "tox.ini"
          ];
          detect_folders = [ ];
          disabled = false;
        };

        quarto = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "⨁ ";
          style = "bold #75AADB";
          detect_extensions = [ ".qmd" ];
          detect_files = [ "_quarto.yml" ];
          detect_folders = [ ];
          disabled = false;
        };

        raku = {
          format = "[$symbol($version-$vm_version )]($style)";
          version_format = "v\${raw}";
          symbol = "🦋 ";
          detect_extensions = [
            "p6"
            "pm6"
            "pod6"
            "raku"
            "rakumod"
          ];
          detect_files = [ "META6.json" ];
          detect_folders = [ ];
          style = "bold 149";
          disabled = false;
        };

        red = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🔺 ";
          detect_extensions = [ "red" ];
          detect_files = [ ];
          detect_folders = [ ];
          style = "red bold";
          disabled = false;
        };

        rlang = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "📐";
          style = "blue bold";
          detect_extensions = [
            "R"
            "Rd"
            "Rmd"
            "Rproj"
            "Rsx"
          ];
          detect_files = [ ".Rprofile" ];
          detect_folders = [ ".Rproj.user" ];
          disabled = false;
        };

        ruby = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "💎 ";
          detect_extensions = [ "rb" ];
          detect_files = [
            "Gemfile"
            ".ruby-version"
          ];
          detect_folders = [ ];
          detect_variables = [
            "RUBY_VERSION"
            "RBENV_VERSION"
          ];
          style = "bold red";
          disabled = false;
        };

        rust = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🦀 ";
          detect_extensions = [ "rs" ];
          detect_files = [ "Cargo.toml" ];
          detect_folders = [ ];
          style = "bold red";
          disabled = false;
        };

        scala = {
          format = "[\${symbol}(\${version} )]($style)";
          version_format = "v\${raw}";
          detect_extensions = [
            "sbt"
            "scala"
          ];
          detect_files = [
            ".scalaenv"
            ".sbtenv"
            "build.sbt"
          ];
          detect_folders = [ ".metals" ];
          symbol = "🆂 ";
          style = "red dimmed";
          disabled = false;
        };

        shell = {
          bash_indicator = "bsh";
          fish_indicator = "fsh";
          zsh_indicator = "zsh";
          powershell_indicator = "psh";
          pwsh_indicator = "psh";
          ion_indicator = "ion";
          elvish_indicator = "esh";
          tcsh_indicator = "tsh";
          xonsh_indicator = "xsh";
          cmd_indicator = "cmd";
          nu_indicator = "nu";
          unknown_indicator = "";
          format = "[$indicator]($style) ";
          style = "white bold";
          disabled = true;
        };

        shlvl = {
          threshold = 2;
          format = "[$symbol$shlvl]($style) ";
          symbol = "↕️ ";
          repeat = false;
          repeat_offset = 0;
          style = "bold yellow";
          disabled = true;
        };

        singularity = {
          format = "[$symbol\[$env\]]($style) ";
          symbol = "";
          style = "bold dimmed blue";
          disabled = false;
        };

        solidity = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${major}.\${minor}.\${patch}";
          symbol = "S ";
          compiler = [ "solc" ];
          detect_extensions = [ "sol" ];
          detect_files = [ ];
          detect_folders = [ ];
          style = "bold blue";
          disabled = false;
        };

        spack = {
          truncation_length = 1;
          symbol = "🅢 ";
          style = "bold blue";
          format = "[$symbol$environment]($style) ";
          disabled = false;
        };

        status = {
          format = "[$symbol$status]($style) ";
          symbol = "❌";
          success_symbol = "";
          not_executable_symbol = "🚫";
          not_found_symbol = "🔍";
          sigint_symbol = "🧱";
          signal_symbol = "⚡";
          style = "bold red";
          recognize_signal_code = true;
          map_symbol = false;
          pipestatus = false;
          pipestatus_separator = "|";
          pipestatus_format = "\[$pipestatus\] => [$symbol$common_meaning$signal_name$maybe_int]($style) ";
          disabled = true;
        };

        sudo = {
          format = "[$symbol]($style)";
          symbol = "🧙 ";
          style = "bold blue";
          allow_windows = false;
          disabled = true;
        };

        swift = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "🐦 ";
          detect_extensions = [ "swift" ];
          detect_files = [ "Package.swift" ];
          detect_folders = [ ];
          style = "bold 202";
          disabled = false;
        };

        terraform = {
          format = "[$symbol$workspace]($style) ";
          version_format = "v\${raw}";
          symbol = "💠";
          detect_extensions = [
            "tf"
            "tfplan"
            "tfstate"
          ];
          detect_files = [ ];
          detect_folders = [ ".terraform" ];
          style = "bold 105";
          disabled = false;
        };

        time = {
          format = "[$time]($style) ";
          use_12hr = false;
          time_format = "%T";
          # time_format = "%H:%M";
          style = "bold yellow";
          utc_time_offset = "local";
          disabled = false;
          time_range = "-";
        };

        typst = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "t ";
          style = "bold #0093A7";
          detect_extensions = [ ".typ" ];
          detect_files = [ "template.typ" ];
          detect_folders = [ ];
          disabled = false;
        };

        username = {
          style_root = "bold #f38ba8";
          style_user = "bold #f9e2af";
          detect_env_vars = [ ];
          format = "[$user]($style)[@](bold #6c7086)";
          show_always = true;
          disabled = false;
          aliases = { };
        };

        vagrant = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "⍱ ";
          detect_extensions = [ ];
          detect_files = [ "Vagrantfile" ];
          detect_folders = [ ];
          style = "cyan bold";
          disabled = false;
        };

        vcsh = {
          symbol = "";
          style = "bold yellow";
          format = "vcsh [$symbol$repo]($style) ";
          disabled = false;
        };

        vlang = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "V ";
          detect_extensions = [ "v" ];
          detect_files = [
            "v.mod"
            "vpkg.json"
            ".vpkg-lock.json"
          ];
          detect_folders = [ ];
          style = "blue bold";
          disabled = false;
        };

        zig = {
          format = "[$symbol($version )]($style)";
          version_format = "v\${raw}";
          symbol = "↯ ";
          style = "bold yellow";
          disabled = false;
          detect_extensions = [ "zig" ];
          detect_files = [ ];
          detect_folders = [ ];
        };

        # -------------------- Custom Modules --------------------

        custom = {
          wifi = {
            command = "iwgetid -r";
            when = "iwgetid";
            symbol = "📶";
            style = "bold #a6e3a1";
            format = "[$symbol$output]($style) ";
            disabled = false;
          };

          uptime = {
            command = "uptime -p | sed 's/up //'";
            when = "true";
            symbol = "⏰";
            style = "bold #cba6f7";
            format = "[$symbol$output]($style) ";
            disabled = true;
          };

          weather = {
            command = "curl -s 'wttr.in?format=1' 2>/dev/null | head -1";
            when = "ping -c 1 wttr.in &>/dev/null";
            symbol = "🌤️";
            style = "bold #f9e2af";
            format = "[$symbol$output]($style) ";
            disabled = true;
          };
        };

        # Environment variable modules
        env_var = {
          SHELL = {
            variable = "SHELL";
            default = "unknown shell";
            format = "[$env_value]($style)";
            style = "bold #fab387";
          };
        };

        # Collection of color palettes
        palettes = { };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = false;
      package = pkgs.zsh;
      antidote = {
        enable = false;
        # package
        # plugins
        # useFriendlyNames
      };
      autocd = true;
      autosuggestion = {
        enable = true;
        # highlight = "fg=#ff00ff,bg=cyan,bold,underline";
        # strategy
      };
      # cdpath
      completionInit = "autoload -U compinit && compinit -i";
      # defaultKeymap
      # dirHashes
      dotDir = config.home.homeDirectory + "/.config/zsh";
      envExtra = '''';
      history = {
        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        # findNoDups
        ignoreAllDups = true;
        # ignoreDups
        # ignorePatterns
        ignoreSpace = true;
        # path
        save = 100000000;
        # saveNoDups
        # share
        size = 1000000000;
      };
      historySubstringSearch = {
        enable = true;
        # searchDownKey
        # searchUpKey
      };
      initContent = ''
        export PATH=$PATH:~/go/bin
        export LANG=en_CA.UTF-8
        ZLE_PROMPT_INDENT=0

        autopair-init
      '';
      # localVariables
      # loginExtra
      # logoutExtra
      oh-my-zsh = {
        enable = false;
        # package
        # custom
        # extraConfig
        plugins = [
          "history"
          "sudo"
        ];
        # theme = "half-life";
      };
      plugins = [
        {
          name = "formarks";
          src = pkgs.fetchFromGitHub {
            owner = "wfxr";
            repo = "formarks";
            rev = "8abce138218a8e6acd3c8ad2dd52550198625944";
            sha256 = "1wr4ypv2b6a2w9qsia29mb36xf98zjzhp3bq4ix6r3cmra3xij90";
          };
          file = "formarks.plugin.zsh";
        }

        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
          };
          file = "zsh-syntax-highlighting.zsh";
        }

        {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.35.0";
            hash = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
          };
        }

        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "400e58a";
            hash = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
          };
        }

        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            hash = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
          };
        }

        {
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "v2.5.1";
            hash = "sha256-kaintLXSfLH7zdLtcoZfVNobCJCap0S/Ldq85wd3krI=";
          };
        }

        {
          name = "zsh-autopair";
          src = pkgs.fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
            sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
          };
          file = "autopair.zsh";
        }
      ];
      prezto = {
        enable = false;
        # package
        autosuggestions = {
          # color
        };
        # caseSensitive
        # color
        completions = {
          # ignoredHosts
        };
        editor = {
          # dotExpansion
          # keymap
          # promptContext
        };
        # extraConfig
        # extraFunctions
        # extraModules
        git = {
          # submoduleIgnore
        };
        gnuUtility = {
          # prefix
        };
        historySubstring = {
          # foundColor
          # globbingFlags
          # notFoundColor
        };
        macOS = {
          # dashKeyword
        };
        # pmoduleDirs
        # pmodules
        prompt = {
          # pwdLength
          # showReturnVal
          # theme
        };
        python = {
          # virtualenvAutoSwitch
          # virtualenvInitialize
        };
        ruby = {
          # chrubyAutoSwitch
        };
        screen = {
          # autoStartLocal
          # autoStartRemote
        };
        ssh = {
          # identities
        };
        syntaxHighlighting = {
          # highlighters
          # pattern
          # styles
        };
        terminal = {
          # autoTitle
          # multiplexerTitleFormat
          # tabTitleFormat
          # windowTitleFormat
        };
        tmux = {
          # autoStartLocal
          # autoStartRemote
          # defaultSessionName
          # itermIntegration
        };
        utility = {
          # safeOps
        };
      };
      # profileExtra
      # sessionVariables
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
        e = "\${EDITOR:-nvim}";
        kc = "kubectl";
        ll = "ls -la";
        pw = "ps aux | grep -v grep | grep -e";
        # vi = "nvim";
        vim = "nvim";
        vim_ready = "sleep 1";

        rg = "rg --color=auto";
        grep = "rg";

        # use 'fc -El 1' for "dd.mm.yyyy"
        # use 'fc -il 1' for "yyyy-mm-dd"
        # use 'fc -fl 1' for mm/dd/yyyy
        history = "fc -il 1";

        # git
        g = "git";

        gsha = "g rev-parse HEAD";
        gsha-short = "g rev-parse --short HEAD";
        branch = "g rev-parse --abbrev-ref HEAD";

        gdown = "git pull origin $(branch) --rebase";
        gch = "g checkout";
        gchb = "gch --detach";
        gsw = "g switch";
        gswC = "gsw -C";
        gswm = "if [[ `git show-ref --verify --quiet refs/heads/main echo $?` -eq 0 ]]; then gf && gch main; else gf && gch main; fi && gdown";
        ga = "g add";
        "ga!" = "ga .";
        gf = "g fetch";
        gs = "git status";
        gc = "g commit --verbose";
        gcm = "gc -m";
        gca = "gc --amend --no-edit";
        gcp = "g cherry-pick";
        gcpc = "gcp --continue";
        gcpa = "gcp --abort";
        gd = "g diff";
        gup = "g push -v origin HEAD:refs/heads/$(branch)";
        gupf = "gup --force-with-lease";
        "gupf!" = "gup --force";
        glog = "git log";
        gloga = "glog --show-signature";
        glogo = "glog --oneline";
        glogog = "glogo --graph";
        gr = "g rebase";
        grm = "gr origin/trunk";
        grc = "gr --continue";
        gra = "gr --abort";
        gbb = "g for-each-ref --color --sort=-committerdate --format=$'%(color:red)%(ahead-behind:HEAD)	%(color:blue)%(refname:short)	%(color:yellow)%(committerdate:relative)	%(color:default)%(describe)' refs/heads/ --no-merged | sed 's/ /	/' | column --separator=$'	' --table --table-columns='Ahead,Behind,Branch Name,Last Commit,Description'";
        gst = "g stash";
        gstp = "gst pop";
        gstl = "gst list";
        c = "codium";
        cdot = "c .";
        csys = "c ~/.sys";
      };
      # shellGlobalAliases
      # syntaxHighlighting = {
      #   enable
      #   package
      #   highlighters
      #   patterns
      #   styles
      # };
      # zplug = {
      #   enable
      #   plugins = {
      #     *.name
      #     *.tags
      #   };
      #   zplugHome
      # };
      # zprof = {
      #   enable
      # };
      # zsh-abbr = {
      #   enable
      #   package
      #   abbreviations
      #   globalAbbreviations
      # };
    };
  };
}
