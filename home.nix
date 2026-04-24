{
  config,
  pkgs,
  jj-starship-pkg,
  ...
}:

{
  home.username = "yuki";
  home.homeDirectory = "/home/yuki";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  # for install terraform pkgs
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

    # basic tools
    git
    neovim
    gh
    fzf
    tree
    unzip
    gcc
    gnumake
    ripgrep
    fd
    jq

    # Node.js
    nodejs_20
    pnpm
    typescript-language-server

    # Python
    (python3.withPackages (
      ps: with ps; [
        pip
        setuptools
      ]
    ))

    # Lua
    stylua
    luarocks
    lua51Packages.jsregexp

    # Nix
    nixfmt
    nixd

    # direnv
    direnv
    nix-direnv

    # YAML/TOML
    yamlfmt
    taplo

    # JS, JSON, CSS
    biome

    # Markdown
    prettier

    # shellscript
    shfmt

    # infla tools
    terraform
    tflint # terraform lint
    awscli2
    ssm-session-manager-plugin # aws

    # claude
    claude-code

    # starship modules
    jj-starship-pkg

  ];

  home.file = {
    ".config/nvim/init.lua".source = ./.config/nvim/init.lua;
    ".config/nvim/lua".source = ./.config/nvim/lua;
    ".config/wezterm".source = ./.config/wezterm;
    ".config/starship.toml".source = ./.config/starship/starship.toml;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    initContent = ''
      # Notify Wezterm of the current directory (OSC 7)
          precmd(){
            printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"
          }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      "credential \"https://github.com\"" = {
        helper = "!${pkgs.gh}/bin/gh auth git-credential";
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "yuki";
        email = "64290748+takagiyuuki@users.noreply.github.com";
      };
      ui = {
        default-command = "log";
        pager = "less -FRX";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
