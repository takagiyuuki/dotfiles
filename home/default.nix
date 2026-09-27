{
  config,
  pkgs,
  root,
  user,
  jj-starship-pkg,
  herdr-pkg,
  ...
}:
{
  home = {
    inherit (user) username;
    homeDirectory = "/home/${user.username}";
    stateVersion = "25.11"; # Please read the comment before changing.
    packages = with pkgs; [
      # Compiler
      gcc
      gnumake
      # Editor, document tools
      neovim
      tree-sitter
      pandoc
      # Git, Jujutsu
      gh
      jjui
      # Terminal Multiplexer
      zellij # kept as fallback while trialing herdr
      herdr-pkg
      # cli tools
      eza
      ripgrep
      fzf
      tree
      unzip
      fd
      jq
      # Git hook manager
      lefthook
      # secret scanner
      gitleaks
      # Node.js
      nodejs_24
      pnpm
      # JavaScript, TypeScript, React, JSON, CSS
      biome
      vscode-langservers-extracted
      typescript-language-server
      tailwindcss-language-server
      astro-language-server
      emmet-language-server
      # YAML/TOML/KDL
      yamlfmt
      yamllint
      taplo
      yaml-language-server
      kdlfmt
      # Go
      go
      gopls
      (lib.hiPrio gotools)
      delve
      golangci-lint
      # Python
      (python3.withPackages (
        ps: with ps; [
          pip
          setuptools
        ]
      ))
      ruff
      pyright
      uv
      # Rust
      rustup
      # Lua
      stylua
      luarocks
      lua51Packages.jsregexp
      lua-language-server
      # Nix
      nixfmt
      statix
      nixd
      # direnv
      nix-direnv
      # Markdown
      prettier
      markdownlint-cli
      marksman
      defuddle # html-to-markdown for Obsidian clipping
      # shellscript
      shfmt
      shellcheck
      bash-language-server
      # GitHub Actions
      actionlint
      # Docker(daemon/CLI is managed by apt; nix provides auxiliary tools only)
      dive
      hadolint
      # terraform, opentofu
      terraform
      tflint
      terraform-ls
      opentofu
      # aws
      awscli2
      ssm-session-manager-plugin
      # AI Agent
      claude-code
      # starship modules
      jj-starship-pkg
    ];
    file = {
      ".config/nvim/init.lua".source = root + "/config/nvim/init.lua";
      ".config/nvim/lua".source = root + "/config/nvim/lua";
      ".config/wezterm".source = root + "/config/wezterm";
      ".config/starship.toml".source = root + "/config/starship/starship.toml";
      ".config/zellij/".source = root + "/config/zellij";
      ".config/herdr/config.toml".source = root + "/config/herdr/config.toml";
      ".config/git/ignore".source = root + "/config/git/ignore";
      ".tflint.hcl".source = root + "/config/tflint/.tflint.hcl";
      ".terraformrc".source = root + "/config/terraform/.terraformrc";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.npm-global"
    ];
    sessionVariables = {
      EDITOR = "nvim";
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    };
    shellAliases = {
      "ls" = "eza --icons -l --git";
      "la" = "eza --icons -la --git";
      "tree" = "eza --icons -la --tree --level=2";
      "cat" = "bat";
      "vim" = "nvim";
    };
    activation = {
      terraformPluginCache = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p "$HOME/.terraform.d/plugin-cache"
      '';
    };
  };
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = user.author.name;
          email = user.author.email;
        };
        init.defaultBranch = "main";
        fetch.prune = true;
        pull.ff = "only";
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        commit.verbose = true;
        merge.conflictStyle = "zdiff3";
        rebase = {
          autoStash = true;
          autosquash = true;
        };
        diff.algorithm = "histogram";
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        column.ui = "auto";
        core.editor = "nvim";
        "credential \"https://github.com\"" = {
          helper = "!${pkgs.gh}/bin/gh auth git-credential";
        };
      };
    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = user.author.name;
          email = user.author.email;
        };
        ui = {
          editor = "nvim";
          default-command = "log";
          pager = "less -FRX";
        };
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      initContent = ''
        # Notify Wezterm of the current directory (OSC 7)
        precmd() {
          printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"
        }

        home() {
          if [[ -e /etc/NIXOS ]]; then
            sudo nixos-rebuild switch --flake "${config.home.homeDirectory}/dotfiles"
          else
            home-manager switch --flake "${config.home.homeDirectory}/dotfiles#${config.home.username}"
          fi
          local exit_code=$?
          if [[ $exit_code -eq 0 ]]; then
            exec zsh -l
          fi
          return $exit_code
        }
      '';
    };
    bat = {
      enable = true;
      config = {
        theme = "ansi";
        ## style = "numbers, changes, header";
        italic-text = "always";
        pager = "less -FR";
      };
      extraPackages = with pkgs.bat-extras; [
        batman
        batwatch
      ];
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
        line-numbers = true;
        navigate = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home-manager.enable = true;
  };
}
