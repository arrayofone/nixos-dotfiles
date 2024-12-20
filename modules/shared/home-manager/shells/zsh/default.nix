{pkgs, lib, config, ...}: {

  options.shells.zsh = {
    enable = lib.mkEnableOption "zsh";
  };

  config.programs = lib.mkIf config.shells.zsh.enable {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = lib.mkMerge [{
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion = {
          enable = true;
      };
      autocd = true;

      oh-my-zsh = {
          enable = true;
          theme = "half-life";
          plugins = [
              "history"
              "sudo"
          ];
      };
                
      initExtra = ''
          export PATH=$PATH:~/go/bin
          export LANG=C.UTF-8
          ZLE_PROMPT_INDENT=0

          autopair-init
      '';

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
        gswm = "if [[ `git show-ref --verify --quiet refs/heads/trunk echo $?` -eq 0 ]]; then gf && gch trunk; else gf && gch main; fi && gdown";
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
        gbb = "g for-each-ref --color --sort=-committerdate --format=$'%(color:red)%(ahead-behind:HEAD)\t%(color:blue)%(refname:short)\t%(color:yellow)%(committerdate:relative)\t%(color:default)%(describe)' refs/heads/ --no-merged | sed 's/ /\t/' | column --separator=$'\t' --table --table-columns='Ahead,Behind,Branch Name,Last Commit,Description'";
        gst = "g stash";
        gstp = "gst pop";
        gstl = "gst list";
        c = "codium";
        cdot = "c .";
        csys = "c ~/.sys";
      };

      history = {
          expireDuplicatesFirst = true;
          save = 100000000;
          size = 1000000000;
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
    }];
  };
}