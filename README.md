# Dotfiles

My dotfiles for a reproducible and idempotent development environment across
platforms.

## Stack

| Category        | Tool                               |
| --------------- | ---------------------------------- |
| Shell           | zsh                                |
| Terminal        | WezTerm                            |
| Editor          | Neovim (lazy.nvim)                 |
| Package Manager | Nix + Home Manager                 |
| VCS             | Jujutsu (jj)                       |
| Formatter       | biome / prettier / nixfmt / stylua |

## Setup

1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

2. Enable flakes

```bash
mkdir ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

3. Bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/takagiyuuki/dotfiles/refs/heads/main/bin/setup.sh | bash
```

4. Apply

```bash
home-manager switch --flake ~/dotfiles#yuki
```

---

# Dotfiles

## 概要

開発環境の再現性・冪等性を目的とした個人dotfiles。

## セットアップ

1. Nix をインストール

```bash
curl -L https://nixos.org/nix/install | sh
```

2. flakes を有効化

```bash
mkdir ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

3. リポジトリをクローンする

```bash
curl -fsSL https://raw.githubusercontent.com/takagiyuuki/dotfiles/refs/heads/main/bin/setup.sh | bash
```

4. 設定を反映させる

```bash
home-manager switch --flake ~/dotfiles#yuki
```

### Appendix

以下のステータスは変更して使用してください。

.home.nix

```nix
home.username = "yuki";
home.homeDirectory = "/home/yuki";
programs.git.settings.user.name
programs.git.settings.user.email
programs.jujutsu.settings.user.name
programs.jujutsu.settings.user.email

```

Windows環境でWeztermを使用している場合、以下のコマンドでシンボリックリンクを作成してください。

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "\\wsl.localhost\Ubuntu\home\username\dotfiles\.config\wezterm"

```
