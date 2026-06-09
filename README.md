# Dotfiles

My dotfiles for a reproducible and idempotent development environment across
platforms.

## Stack

| Category        | Tool               |
| --------------- | ------------------ |
| Shell           | zsh + starship     |
| Terminal        | WezTerm            |
| Editor          | Neovim (lazy.nvim) |
| Package Manager | Nix + Home Manager |
| VCS             | Jujutsu (jj), git  |

## Setup

### 1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

### 2. Enable flakes

```bash
mkdir ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 3. Bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/takagiyuuki/dotfiles/refs/heads/main/bin/setup.sh | bash
```

### 4. Apply

```bash
home # custom home-manager switch command.
```

### Appendix

Customize the following fields in `home.nix` for your own environment.

```nix
home.username
home.homeDirectory
programs.git.settings.user.name
programs.git.settings.user.email
programs.jujutsu.settings.user.name
programs.jujutsu.settings.user.email
```

#### Windows + WezTerm

If you use WezTerm on Windows, create a symbolic link to the config directory:

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "\\wsl.localhost\Ubuntu\home\username\dotfiles\.config\wezterm"
```
