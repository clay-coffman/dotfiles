# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

# Dotfiles Repository - Claude Code Context

**Repository**: Chezmoi-based dotfiles for development environment
**Location**: `/home/clay/.local/share/chezmoi`
**Type**: Dotfile management system (Infrastructure/Configuration)
**Primary Tool**: Chezmoi (dotfile manager)
**Remote**: https://github.com/clay-coffman/dotfiles.git

---

## Repository Overview

This is a personal dotfiles repository managed by **Chezmoi**, a tool for managing configuration files across machines. The repository contains configurations for a modern, keyboard-driven development environment optimized for speed and productivity.

**Key Characteristics**:
- Cross-platform dotfiles manager using Chezmoi
- 1Password integration for secrets management
- Template-based configurations using Go templating syntax
- Currently running on Fedora Linux (ThinkPad)
- Emphasis on shell productivity, code editing, and window management
- Multi-language development environment (Go, Node.js, Ruby, Rust, Python, Lua)

---

## Directory Structure

```
/home/clay/.local/share/chezmoi/
├── .git/                          # Git repository metadata
├── .chezmoiignore                 # Chezmoi ignore patterns
├── .claude/                       # Claude Code specific config
├── README.md                      # Installation and usage guide
├── dot_Brewfile                   # Homebrew package list (macOS)
├── dot_tool-versions              # asdf runtime versions
├── dot_tmux.conf.tmpl             # Tmux configuration (template)
├── dot_mcp.json                   # MCP servers (deployed)
├── private_dot_zshrc.tmpl         # Zsh shell configuration (template, private)
├── private_dot_gitconfig          # Git configuration (private)
│
├── dot_config/                    # Main configuration directory
│   ├── aerospace/                 # Tiling window manager config
│   │   └── aerospace.toml         # i3-like tiling window manager
│   ├── bat/                       # Bat syntax highlighter config
│   │   └── config                 # Theme: github-dark-custom
│   ├── kitty/                     # GPU-accelerated terminal emulator
│   │   ├── kitty.conf             # Terminal settings (font, colors, behavior)
│   │   └── current-theme.conf     # Active theme configuration
│   ├── nvim/                      # Neovim editor (LazyVim starter)
│   │   ├── init.lua               # Neovim entry point
│   │   ├── stylua.toml            # Lua formatter config
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── lazy.lua       # Lazy.nvim plugin manager setup
│   │       │   ├── options.lua    # Editor options (tabs, wrap, etc.)
│   │       │   ├── keymaps.lua    # Custom key bindings
│   │       │   └── autocmds.lua   # Auto-commands and hooks
│   │       ├── plugins/           # Individual plugin configurations
│   │       │   ├── colorscheme.lua       # GitHub Dark theme
│   │       │   ├── conform.lua           # Code formatter
│   │       │   ├── treesitter.lua        # Syntax highlighting
│   │       │   ├── blink.lua             # Completion engine
│   │       │   ├── neo-tree.lua          # File tree explorer
│   │       │   ├── fzf-lua.lua           # Fuzzy finder
│   │       │   ├── nvim-lint.lua         # Linter integration
│   │       │   ├── toggleterm.lua        # Terminal integration
│   │       │   ├── render-markdown.lua   # Markdown rendering
│   │       │   ├── images.lua            # Image display support
│   │       │   ├── overseer.lua          # Task runner
│   │       │   ├── vim-tmux-navigator.lua # Tmux/vim navigation
│   │       │   ├── auto-dark-mode.lua    # Theme switching
│   │       │   ├── snacks.lua            # Utility functions
│   │       │   ├── lualine.lua           # Statusline
│   │       │   └── colorful-menu.lua     # UI enhancements
│   │       └── overseer/template/user/   # Task templates
│   │           ├── init.lua
│   │           └── make_run.lua
│   ├── lazygit/                   # Git TUI configuration
│   │   └── config.yml             # Extensive keybindings and settings
│   ├── pgcli/                     # PostgreSQL CLI config
│   ├── ripgrep/                   # Code search tool config
│   │   └── config                 # Smart case, hidden files, colors
│   ├── yazi/                      # Terminal file manager config
│   │   └── yazi.toml
│   ├── tmux/                      # Tmux plugins and themes
│   │   └── themes/                # GitHub Dark/Light themes
│   ├── mcp/                       # Model Context Protocol servers
│   │   └── base-servers.json.tmpl # Claude.app MCP server definitions
│   ├── scripts/                   # Helper scripts
│   │   └── executable_merge-claude-config.sh # Merges MCP configs
│   ├── starship.toml              # Shell prompt configuration (377 lines)
│   ├── gtk-3.0/                   # GTK3 settings (Linux)
│   ├── gtk-4.0/                   # GTK4 settings (Linux)
│   └── fontconfig/                # Font configuration
│
├── dot_local/                     # Local user data
├── private_dot_ssh/               # SSH configuration (private)
└── private_dot_atuin/             # Atuin shell history sync

```

---

## Key Technologies & Tools

### Shell & Terminal
- **Zsh** + **Zi Plugin Manager** - Modern shell with lazy-loaded plugins
  - Plugins: zsh-vi-mode, zsh-zoxide, git, alias-finder
- **Starship** - Cross-shell prompt with git integration (377 lines of config)
- **Kitty** - GPU-accelerated terminal with AtkynsonMono Nerd Font
- **Tmux** - Terminal multiplexer with Ctrl+a prefix and GitHub Dark theme
- **Atuin** - Shell history sync across machines

### Code Editor
- **Neovim** with **LazyVim** starter configuration
- **Lazy.nvim** - Plugin manager with automatic lazy loading
- Key plugins:
  - **Treesitter** - Advanced syntax highlighting
  - **Blink** - Fast completion engine
  - **Conform.nvim** - Code formatting (prettier, sqlfluff, djlint, bake)
  - **FZF-lua** - Fuzzy finder integration
  - **Overseer** - Task runner with make templates
  - **vim-tmux-navigator** - Seamless pane navigation
  - **render-markdown** - Live markdown preview
  - **lualine** - Statusline

### Development Tools
- **Git** - Version control with 1Password SSH signing
- **asdf** - Version manager for multiple languages
- **fzf** - Fuzzy finder for CLI with bat preview
- **ripgrep** - Fast code search (smart case, hidden files)
- **PostgreSQL** - Database with pgcli client
- **bat** - Syntax-highlighted cat replacement (github-dark-custom theme)
- **yazi** - Terminal file manager with cd-on-exit
- **lazygit** - Git TUI with extensive keybindings

### Window Management
- **AeroSpace** - i3-like tiling window manager
  - Alt+hjkl navigation
  - Workspace auto-assignment
  - 5px gaps, mouse follows focus

### Languages (via asdf)
```
golang 1.25.3
nodejs 24.10.0
ruby 3.4.7
rust 1.90.0
python 3.13.0
lua 5.1
```

### AI & Claude Integration
- **Model Context Protocol (MCP) Servers**:
  - filesystem - File system access
  - git - Git operations
  - github - GitHub API
  - postgres - Database queries
  - playwright - Web automation
  - memory - Persistent memory
  - time - Time queries
  - context7 - Upstash integration
  - dash-api - Documentation lookup
  - sequential-thinking - AI reasoning
- **Custom function**: `mcp-init [project_dir]` - Initialize MCP config for projects
- **Helper script**: `merge-claude-config.sh` - Merges base MCP servers with project config

---

## Important Configuration Files

### Chezmoi & Templates
- `.chezmoiignore` - Files to exclude from management
- `*.tmpl` files - Use Go templating syntax

### Template Variables & Syntax
```go
// Common template variables
{{ .chezmoi.homeDir }}        // User's home directory
{{ .chezmoi.os }}              // Operating system (darwin, linux)
{{ .chezmoi.username }}        // Current username

// 1Password integration
{{ onepasswordRead "op://vault/item/field" }}

// Conditionals
{{ if eq .chezmoi.os "darwin" }}
  # macOS-specific config
{{ else if eq .chezmoi.os "linux" }}
  # Linux-specific config
{{ end }}

// Variable assignment
{{ $apiKey := onepasswordRead "op://Personal/Gemini API/credential" }}
export GEMINI_API_KEY="{{ $apiKey }}"
```

### Shell Configuration (`private_dot_zshrc.tmpl`)
- **Framework**: Zi (modern plugin manager)
- **Plugins**: zsh-vi-mode, zsh-zoxide, git, alias-finder
- **History**: 10,000 entries, shared across sessions, XDG-compliant
- **FZF Integration**: Ripgrep with bat preview, 40% height
- **Environment Variables**: XDG paths, EDITOR=nvim, custom PATH
- **Key Aliases**:
  - `v` → nvim
  - `cat` → bat
  - `open` → xdg-open (Linux)
  - `update` → sudo dnf update
- **Custom Functions**:
  - `mcp-init` - Initialize MCP for projects
  - `y()` - Yazi with directory change on exit

### Neovim Configuration
- **Entry**: `lua/config/lazy.lua` - Bootstraps Lazy.nvim
- **Options**: Tab width 2, text width 80, wrap enabled, conceallevel 2
- **Colorscheme**: GitHub Dark/Light with auto-detection via gsettings
- **Formatters** (via Conform.nvim):
  - Makefile → bake
  - Markdown/YAML → prettierd, prettier
  - JavaScript/TypeScript → prettier
  - SQL → sqlfluff
  - Django HTML → djlint
- **Overseer Task Templates**: Make run support
- **vim-tmux-navigator**: Ctrl+hjkl works seamlessly between vim and tmux

### Tmux Configuration (`dot_tmux.conf.tmpl`)
- **Prefix**: Ctrl+a
- **Theme**: Dynamic GitHub Dark/Light based on system settings
- **Plugins**: TPM, vim-tmux-navigator, resurrect, continuum, battery, online-status
- **Status Bar**: Top position, session name, battery, time
- **Key Bindings**: v/s for splits, H/J/K/L for resize, vi mode in copy

### Git Configuration (`private_dot_gitconfig`)
- **User**: Clay Coffman (claymcoffman@gmail.com)
- **Signing**: SSH via 1Password (`/opt/1Password/op-ssh-sign`)
- **Default Branch**: main
- **Diff Tool**: nvimdiff

---

## Commands & Workflows

### Common Chezmoi Commands
```bash
# Apply dotfiles from this repo to the system
chezmoi apply

# Preview changes before applying
chezmoi diff
chezmoi apply --dry-run --verbose

# Update from remote repository
chezmoi update
chezmoi git pull -- --rebase && chezmoi apply

# Edit a config file directly (opens in $EDITOR)
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/nvim/init.lua

# Add a new config file to management
chezmoi add ~/.config/some-new-config

# Navigate to the source directory
chezmoi cd

# Working with git in the source directory
chezmoi cd
git add .
git commit -m "message"
git push
exit  # return to previous directory
```

### Working with Templates
```bash
# Edit a template file
chezmoi edit ~/.zshrc  # Opens private_dot_zshrc.tmpl

# Test template rendering without applying
chezmoi execute-template < private_dot_zshrc.tmpl

# See what variables are available
chezmoi data

# Add a new templated file
echo 'export KEY="{{ onepasswordRead "op://vault/item/field" }}"' > dot_myconfig.tmpl
chezmoi add --template ~/.myconfig
```

### Testing Changes Safely
```bash
# 1. Always preview changes first
chezmoi diff

# 2. Test specific files
chezmoi apply --dry-run ~/.zshrc

# 3. Apply with verbose output
chezmoi apply --verbose

# 4. If something goes wrong, re-apply from git
chezmoi git checkout .
chezmoi apply
```

### Installation
```bash
# One-liner for fresh machine
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply clay-coffman

# Or if chezmoi already installed
chezmoi init --apply https://github.com/clay-coffman/dotfiles.git
```

### Manual Setup After Install
1. Zi (Zsh plugin manager) auto-installs on first shell launch
2. TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
3. Neovim: Launch nvim to auto-install plugins via Lazy
4. 1Password CLI: Install and run `op signin`
5. AeroSpace: Start service and load config

### MCP Configuration Workflow
```bash
# Initialize MCP for a project
mcp-init ~/my-project  # Creates/updates .claude/claude_mcp_config.json

# The mcp-init function:
# 1. Creates .claude directory in project
# 2. Copies base MCP servers configuration
# 3. Adds project-specific filesystem server
# 4. Merges with any existing config

# Manual merge if needed
~/.config/scripts/merge-claude-config.sh
```

---

## File Management Rules

### What Gets Ignored (`.chezmoiignore`)
- `*.md`, `README.md`, `LICENSE` - Documentation
- `.git`, `.gitignore` - Git metadata
- `.DS_Store`, `.localized` - System files
- `*.swp`, `*.tmp` - Temporary files
- `.idea`, `.vscode` - IDE config
- `.ssh/id_*`, `.gnupg`, `.aws/credentials` - Sensitive keys
- `.config/gh/hosts.yml` - GitHub hosts config
- `.cache`, `.npm`, history files - Temporary data
- `nvim/lazy-lock.json`, `lazygit/state.yml` - Dynamic state files
- Compiled assets: `.dmg`, `.pkg`, `.deb`, `.rpm`
- Plugin managers: `.tmux/plugins/**`, `.local/share/nvim/**`

### Chezmoi File Naming Conventions
- `dot_` prefix → `.` (e.g., `dot_zshrc` → `.zshrc`)
- `private_` prefix → File created with 600 permissions
- `executable_` prefix → File created with executable permissions
- `.tmpl` suffix → Template file processed by Chezmoi
- `exact_` prefix → Directory contents managed exactly

---

## Common Pitfalls & Solutions

### Working with Chezmoi Templates
**Problem**: Edited `~/.zshrc` directly but changes lost after `chezmoi apply`
**Solution**: Always edit via `chezmoi edit ~/.zshrc` or edit `private_dot_zshrc.tmpl` directly

**Problem**: Template syntax errors break config files
**Solution**: Test templates first with `chezmoi execute-template < file.tmpl`

### File Paths in Claude Code
**Important**: When working in this repository, always use absolute paths:
- `/home/clay/.local/share/chezmoi/dot_config/nvim/init.lua`
- `/home/clay/.local/share/chezmoi/private_dot_zshrc.tmpl`

### Secrets and 1Password
**Problem**: `chezmoi apply` fails with 1Password errors
**Solution**: Ensure logged in with `op signin` and vault names match in templates

### Plugin Installation
**Problem**: Neovim plugins not loading
**Solution**: Launch nvim and run `:Lazy install`, plugins auto-install on first launch

**Problem**: Tmux plugins not working
**Solution**: Install TPM first, then press `Ctrl-a I` to install plugins

---

## Claude Code Specific Notes

### Navigation Tips
1. **This is the source directory** - Files here are templates/sources, not the actual deployed configs
2. **Use absolute paths** - Always use full paths when referencing files
3. **Check both source and target** - Some issues require checking both template and deployed file
4. **Template syntax matters** - Pay attention to `.tmpl` files and Go template syntax

### When Editing Configurations
1. **Identify if it's a template**: Check for `.tmpl` suffix
2. **Preserve exact formatting**: Templates are sensitive to spacing
3. **Test before applying**: Use `chezmoi diff` to preview changes
4. **Use proper Chezmoi commands**: Don't edit deployed files directly

### Common Tasks for Claude Code
```bash
# Add a new Neovim plugin
chezmoi edit ~/.config/nvim/lua/plugins/newplugin.lua
# Then add plugin configuration

# Update shell configuration
chezmoi edit ~/.zshrc
# Make changes to private_dot_zshrc.tmpl

# Add new tool configuration
chezmoi add ~/.config/new-tool/config
chezmoi apply

# Debug template rendering
chezmoi execute-template < private_dot_zshrc.tmpl | less
```

---

## Philosophy & Design

The configuration is optimized for:
1. **Speed**: Fast shell startup with lazy-loading, optimized prompts
2. **Productivity**: Keyboard-driven workflow with extensive custom keybindings
3. **Aesthetics**: Consistent GitHub Dark theme across all tools
4. **Portability**: Easy deployment to new machines via Chezmoi
5. **Security**: Secrets in 1Password, never committed to git
6. **Consistency**: Templates ensure same config across machines
7. **AI Integration**: Full MCP support for Claude.app with 10 servers

---

## Recent Activity & Status

### Current State
- **Platform**: Fedora Linux (ThinkPad)
- **Branch**: main

### Key Tool Versions
- Neovim with LazyVim
- Tmux with TPM plugins
- Zsh with Zi plugin manager
- All language runtimes via asdf

---

**Maintained by**: Clay Coffman
**Repository**: https://github.com/clay-coffman/dotfiles.git
