# 🚀 dotfiles

Personal configuration files managed by **takagiyuuki**.  
Optimized for **WSL2 (Ubuntu)**, **Neovim**, and **WezTerm**.

---

## 🛠 Features 

* ⌨️ Editor: Neovim with lazy.nvim (LSP, Telescope, etc.)
* 💻 Terminal: WezTerm with Lua-based custom keybindings.
* 🐚 Shell: zsh configured for an efficient CLI workflow.
* 🔗 Automation: Symbolic link management via symlinks.sh.

## 📂 Structure 

.
├── nvim/           # Neovim (init.lua, plugins via lazy.nvim)
├── wezterm/        # WezTerm (Lua configuration & keybinds)
├── zsh/            # Zsh configuration (.zshrc)
├── scripts/        # Automation scripts (Symbolic links)
└── .gitignore      # Git ignore patterns

## 🚀 Installation

### 1. Clone the repository

```bash
git clone git@github.com:takagiyuuki/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Create symbolic links

Run the provided script to link configuration files to your home directory.

```bash
chmod +x scripts/symlinks.sh
./scripts/symlinks.sh

```

## 🏗 Roadmap

- [ ] Shell: 🐚 Integration of Zsh frameworks (Oh My Zsh / Prezto)
- [ ] Windows: 🪟 PowerShell scripts for auto-linking on Windows
- [ ] Appearance: 🎨 Unifying color schemes (Catppuccin/Nightfox)
- [ ] LSP: 🏗️ Enhancing LSP for Terraform, Ansible, and Python
- [ ] Container: 🐳 DevContainer configurations for consistent environments

## 💻 Requirements

* OS: Ubuntu (on WSL2) / Windows
* Fonts: HackGen Console NF (Nerd Fonts)
* Tools: git, zsh, neovim, wezterm

