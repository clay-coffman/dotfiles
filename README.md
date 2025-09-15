## Quick Start

### One-liner Installation

Install these dotfiles on a new machine with a single command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply clay-coffman
```

### Alternative Installation

If you already have chezmoi installed:

```bash
chezmoi init --apply https://github.com/clay-coffman/dotfiles.git
```

## 📦 What's Included

### Shell & Terminal
- **Zsh** - Shell with Zim framework for fast startup
- **Tmux** - Terminal multiplexer with custom config
- **Kitty** - GPU-accelerated terminal emulator
- **Starship** - Cross-shell prompt with git integration

### Development
- **Neovim** - LazyVim configuration with LSP support
- **Git** - Global gitconfig with aliases
- **PostgreSQL/pgcli** - Database tools configuration

### macOS Window Management
- **Yabai** - Tiling window manager
- **SKHD** - Simple hotkey daemon for keyboard shortcuts
- **Aerospace** - Window management utilities

### CLI Tools
- **btop** - System monitoring
- **Yazi** - Terminal file manager
- **Fastfetch** - System info display
- **Spotify Player** - Terminal Spotify client
- **GitHub CLI** - GitHub from the terminal

## 🔧 Prerequisites

### macOS
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install git
```

### 1Password CLI (for secrets management)
```bash
brew install --cask 1password-cli
op signin
```

## 🔐 Secrets Management

API keys and secrets are managed via 1Password. Ensure you have the following items in your 1Password vault:

- **Gemini API** - Field: `credential`
- **OpenRouter API** - Field: `api_key`

The setup will automatically fetch these from 1Password when needed.

## 📝 Manual Setup After Installation

### 1. Zim Framework
Zim will auto-install on first shell launch:
```bash
exec zsh
```

### 2. Tmux Plugin Manager
Install TPM and plugins:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Press `prefix + I` in tmux to install plugins
```

### 3. Neovim
Launch Neovim and let LazyVim install plugins:
```bash
nvim
# Plugins will auto-install on first launch
```

### 4. Window Management (macOS)
```bash
# Start Yabai and SKHD services
yabai --start-service
skhd --start-service

# Start Sketchybar
brew services start sketchybar
```

### 5. Font Installation
For icons and symbols to display correctly:
```bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install --cask sf-symbols
```

## 🛠️ Daily Usage

### Update dotfiles from repo
```bash
chezmoi update
```

### Edit a config file
```bash
chezmoi edit ~/.zshrc
chezmoi apply
```

### Add a new config file
```bash
chezmoi add ~/.config/some-new-config
chezmoi cd
git add .
git commit -m "Add new config"
git push
```

### Pull changes and apply
```bash
chezmoi git pull -- --rebase
chezmoi apply
```

## ⚙️ Configuration

### Chezmoi config location
`~/.config/chezmoi/chezmoi.toml`

### Machine-specific settings
Edit `~/.config/chezmoi/chezmoi.toml` to customize:
```toml
[data]
    email = "your-email@example.com"
    name = "Your Name"
    machine = "personal"  # or "work"
```

## 🎨 Customization

### Key Bindings

#### Yabai + SKHD (Window Management)
- `alt + h/j/k/l` - Focus window
- `shift + alt + h/j/k/l` - Move window
- `alt + f` - Toggle fullscreen
- `alt + t` - Toggle float

#### Tmux
- `Ctrl+b` - Prefix key
- `prefix + |` - Split vertical
- `prefix + -` - Split horizontal
- `prefix + h/j/k/l` - Navigate panes

### Themes
- Kitty: Configured for Catppuccin theme
- Neovim: LazyVim with custom colorscheme
- Starship: Custom prompt configuration

## 📚 Components Documentation

- [Chezmoi](https://www.chezmoi.io/) - Dotfile manager
- [Yabai](https://github.com/koekeishiya/yabai) - Window manager
- [SKHD](https://github.com/koekeishiya/skhd) - Hotkey daemon
- [Sketchybar](https://felixkratz.github.io/SketchyBar/) - Status bar
- [LazyVim](https://www.lazyvim.org/) - Neovim configuration
- [Zim](https://zimfw.sh/) - Zsh configuration framework
- [Starship](https://starship.rs/) - Shell prompt

## 🐛 Troubleshooting

### Chezmoi diff shows unexpected changes
```bash
chezmoi diff
chezmoi forget <file>  # Remove from management
chezmoi add <file>     # Re-add with correct state
```

### 1Password CLI not working
```bash
op signin  # Re-authenticate
chezmoi apply --verbose  # See detailed errors
```

### Icons not displaying
- Ensure Nerd Font is installed and selected in terminal

### Yabai/SKHD not working
- May need to partially disable SIP on macOS
- Check accessibility permissions in System Settings

---

<details>
<summary>🎯 Philosophy</summary>

These dotfiles are optimized for:
- **Speed**: Fast shell startup with Zim
- **Productivity**: Keyboard-driven workflow
- **Aesthetics**: Clean, minimal interface
- **Portability**: Easy to deploy on new machines
- **Security**: Secrets in 1Password, never in git

</details>

