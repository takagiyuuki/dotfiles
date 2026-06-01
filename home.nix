{
  config,
  pkgs,
  jj-starship-pkg,
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
    username = "yuki";
    homeDirectory = "/home/yuki";
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
      zellij
      # cli tools
      eza
      ripgrep
      fzf
      tree
      unzip
      fd
      jq
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
      # shellscript
      shfmt
      bash-language-server
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
      ".config/git/ignore".source = ./.config/git/ignore;
    };
    sessionPath = [
      "{$config.home.homeDirectory}/.npm-global"
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
    };
  };
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "yuki";
          email = "64290748+takagiyuuki@users.noreply.github.com";
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
          name = "yuki";
          email = "64290748+takagiyuuki@users.noreply.github.com";
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
