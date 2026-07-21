{
  config,
  pkgs,
  jj-starship-pkg,
  herdr-pkg,
  user,
  ...
}:
{
  # Allow unfree only for specific packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "terraform"
      "claude-code"
    ];
  home = {
    username = user.username;
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
      ".config/nvim/init.lua".source = ./.config/nvim/init.lua;
      ".config/nvim/lua".source = ./.config/nvim/lua;
      ".config/wezterm".source = ./.config/wezterm;
      ".config/starship.toml".source = ./.config/starship/starship.toml;
      ".config/zellij/".source = ./.config/zellij;
      ".config/herdr/config.toml".source = ./.config/herdr/config.toml;
      ".config/git/ignore".source = ./.config/git/ignore;
      # Global config
      ".tflint.hcl".source = ./.tflint.hcl;
      ".terraformrc".source = ./.terraformrc;
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
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
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
          home-manager switch --flake "${config.home.homeDirectory}/dotfiles#${config.home.username}"
          local exit_code=$?
          if [[ $exit_code -eq 0 ]]; then
            exec zsh -l
          fi
          return $exit_code
        }

        # Launch zellij in an interactively chosen directory.
        # Layout panes inherit this cwd, so nvim/claude start there.
        zj() {
          [[ -n "$ZELLIJ" ]] && { echo "already inside zellij" >&2; return 1; }
          local dir="$1"
          if [[ -z "$dir" ]]; then
            # Search roots: dotfiles itself + project dirs under ~/dev. Adjust to taste.
            dir=$( { echo "$HOME/dotfiles"; fd --type d --max-depth 2 . "$HOME/dev"; } | fzf ) || return
          fi
          cd "$dir" || return
          zellij
        }
      '';
    };
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
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
