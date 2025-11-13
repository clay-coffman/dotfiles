# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

# Dotfiles Repository - Claude Code Context

**Repository**: Chezmoi-based dotfiles for macOS development environment
**Location**: `/Users/clay/.local/share/chezmoi`
**Type**: Dotfile management system (Infrastructure/Configuration)
**Primary Tool**: Chezmoi (dotfile manager)
**Remote**: https://github.com/clay-coffman/dotfiles.git

---

## Repository Overview

This is a personal dotfiles repository managed by **Chezmoi**, a tool for managing configuration files across machines. The repository contains configurations for a modern, keyboard-driven macOS development environment optimized for speed and productivity.

**Key Characteristics**:
- Cross-platform dotfiles manager using Chezmoi
- 1Password integration for secrets management
- Template-based configurations using Go templating syntax
- Tailored for macOS (with optional Linux support)
- Emphasis on shell productivity, code editing, and window management
- Multi-language development environment (Go, Node.js, Ruby, Rust, Python, Lua)

---

## Directory Structure

```
/Users/clay/.local/share/chezmoi/
├── .git/                          # Git repository metadata
├── .chezmoiignore                 # Chezmoi ignore patterns
├── .claude/                       # Claude Code specific config (mostly empty)
├── README.md                       # Installation and usage guide (218 lines)
├── dot_Brewfile                   # Homebrew package list
├── dot_tool-versions              # asdf runtime versions
├── dot_tmux.conf.tmpl             # Tmux configuration (template)
├── private_dot_zshrc.tmpl         # Zsh shell configuration (template, private)
│
├── dot_config/                    # Main configuration directory
│   ├── aerospace/                 # macOS window manager config
│   │   └── aerospace.toml         # i3-like tiling window manager
│   ├── bat/                       # Bat syntax highlighter config
│   ├── kitty/                     # GPU-accelerated terminal emulator
│   │   ├── kitty.conf             # Terminal settings (font, colors, behavior)
│   │   ├── current-theme.conf     # Active theme configuration
│   │   └── backup/                # Backup of previous configurations
│   ├── nvim/                      # Neovim editor (LazyVim starter)
│   │   ├── init.lua               # Neovim entry point
│   │   ├── README.md              # LazyVim documentation
│   │   ├── stylua.toml            # Lua formatter config
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── lazy.lua       # Lazy.nvim plugin manager setup
│   │       │   ├── options.lua    # Editor options (tabs, wrap, etc.)
│   │       │   ├── keymaps.lua    # Custom key bindings
│   │       │   └── autocmds.lua   # Auto-commands and hooks
│   │       └── plugins/           # Individual plugin configurations (18 files)
│   │           ├── colorscheme.lua       # GitHub Dark theme
│   │           ├── conform.lua           # Code formatter (prettier, sqruff, djlint, bake)
│   │           ├── treesitter.lua        # Syntax highlighting
│   │           ├── blink.lua             # Completion engine
│   │           ├── neo-tree.lua          # File tree explorer
│   │           ├── fzf-lua.lua           # Fuzzy finder
│   │           ├── nvim-lint.lua         # Linter integration
│   │           ├── toggleterm.lua        # Terminal integration
│   │           ├── render-markdown.lua   # Markdown rendering
│   │           ├── images.lua            # Image display support
│   │           ├── overseer.lua          # Task runner (C build/run support)
│   │           ├── vim-tmux-navigator.lua # Seamless tmux/vim navigation
│   │           ├── auto-dark-mode.lua    # Theme switching
│   │           ├── snacks.lua            # Utility functions
│   │           └── colorful-menu.lua     # UI enhancements
│   ├── lazygit/                   # Git TUI configuration
│   ├── pgcli/                     # PostgreSQL CLI config
│   ├── raycast/                   # Raycast app launcher config
│   ├── ripgrep/                   # Code search tool config
│   ├── yazi/                      # Terminal file manager config
│   ├── tmux/                      # Tmux plugins and themes
│   │   └── themes/                # GitHub Dark/Light themes
│   ├── mcp/                       # Model Context Protocol servers
│   │   └── base-servers.json.tmpl # Claude.app MCP server definitions
│   ├── scripts/                   # Helper scripts
│   │   └── executable_merge-claude-config.sh # Merges MCP configs
│   ├── starship.toml              # Shell prompt configuration (377 lines)
│   ├── dot_prettierrc.yaml        # Code formatter defaults
│   └── taplo.toml                 # TOML formatter config
│
└── dot_local/                     # Local user data (not synced)
    └── [application data]

```

---

## Key Technologies & Tools

### Shell & Terminal
- **Zsh** + **Oh-My-Zsh Framework** - Shell with extensive plugin ecosystem
  - Plugins: git, alias-finder, asdf, zoxide, zsh-vi-mode
- **Starship** - Cross-shell prompt with git integration (377 lines of config)
- **Kitty** - GPU-accelerated terminal emulator with JetBrains Mono font
- **Tmux** - Terminal multiplexer with Ctrl+a prefix and GitHub Dark theme

### Code Editor
- **Neovim** with **LazyVim** starter configuration
- **Lazy.nvim** - Plugin manager with automatic lazy loading
- Key plugins:
  - **Treesitter** - Advanced syntax highlighting
  - **Blink** - Fast completion engine
  - **Conform.nvim** - Code formatting (prettier, sqruff, djlint, bake for Makefiles)
  - **FZF-lua** - Fuzzy finder integration
  - **Overseer** - Task runner with C build/run templates
  - **vim-tmux-navigator** - Seamless pane navigation between tmux and vim
  - **render-markdown** - Live markdown preview
  - **images.lua** - Display images in buffer

### Development Tools
- **Git** - Version control with aliases and configurations
- **asdf** - Version manager for multiple languages
- **fzf** - Fuzzy finder for CLI with bat preview
- **ripgrep** - Fast code search
- **PostgreSQL 16** - Database with pgcli client
- **bat** - Syntax-highlighted cat replacement
- **yazi** - Terminal file manager with cd-on-exit
- **atuin** - Shell history sync across machines

### macOS-Specific
- **AeroSpace** - i3-like tiling window manager (active config)
  - Alt+hjkl navigation
  - Workspace auto-assignment (Kitty→1, Claude→6, Spotify→S)
- **Yabai** - Alternative tiling window manager (config available but not active)
- **SKHD** - Simple hotkey daemon (for window management)
- **borders** - Window border utility for AeroSpace

### Languages (via asdf)
```
golang 1.25.3
nodejs 24.10.0
ruby 3.4.7
rust 1.90.0
python 3.14.0t
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

### Package Management
- **Homebrew** - macOS package manager (51 lines in Brewfile)
- **npm/pnpm** - JavaScript package managers
- **JetBrains Mono Nerd Font** - Terminal font with icons

---

## Important Configuration Files

### Chezmoi & Templates
- `.chezmoiignore` - Files to exclude from management (75 lines of patterns)
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
- **Framework**: Oh-My-Zsh with plugins (git, alias-finder, asdf, zoxide, zsh-vi-mode)
- **Secrets**: Reads from 1Password (4 API keys)
- **Environment Variables**: Editor, XDG paths, API keys
- **PATH**: Includes LLVM, PostgreSQL, pnpm paths
- **Custom Functions**:
  - `mcp-init` - Initialize MCP for projects
  - `y()` - Yazi with directory change on exit
- **Aliases**: `v` → nvim, `cat` → bat with auto theme

### Neovim Configuration Details
- **Entry**: `lua/config/lazy.lua` - Bootstraps Lazy.nvim
- **Options**: Markdown support, tab width 2, text width 80, hard wrap enabled
- **Formatters** (via Conform.nvim):
  - Makefile → bake
  - Markdown/YAML → prettier/prettierd
  - JavaScript/TypeScript → prettier
  - SQL → sqruff
  - Django HTML → djlint
- **Overseer Task Templates**: C compiler with build & run commands
- **vim-tmux-navigator**: Ctrl+hjkl works seamlessly between vim splits and tmux panes
- **Theme**: GitHub Dark Default with italic comments, bold keywords

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

# 3. Apply with verbose output to see what's happening
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
1. Oh-My-Zsh auto-installs on first shell launch
2. TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
3. Neovim: Launch nvim to auto-install plugins via Lazy
4. 1Password CLI: `brew install --cask 1password-cli` + `op signin`
5. AeroSpace: Start service and load config
6. Fonts: Install via Homebrew (`brew bundle` in repo)

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

### Secrets Management
- Managed via **1Password CLI** integration
- Required items in 1Password vault:
  - Gemini API Key (field: `credential`)
  - GitHub Token (field: `credential`)
  - Ref API Key (field: `credential`)
  - Context7 API Key (field: `credential`)
  - OpenRouter API (field: `api_key`)

---

## File Management Rules

### What Gets Ignored (`.chezmoiignore`)
- `*.md`, `README.md`, `LICENSE` - Documentation
- `.git`, `.gitignore` - Git metadata
- `.DS_Store`, `.localized` - macOS system files
- `*.swp`, `*.tmp` - Temporary files
- `.idea`, `.vscode` - IDE config
- `.ssh/id_*`, `.gnupg`, `.aws/credentials` - Sensitive keys
- `.config/gh/hosts.yml` - GitHub hosts config
- `.cache`, `.npm`, history files - Temporary data
- `nvim/lazy-lock.json`, `lazygit/state.yml` - Dynamic state files
- Platform-specific: Excludes macOS configs on Linux and vice versa
- Compiled assets: `.dmg`, `.pkg`, `.deb`, `.rpm`
- Plugin managers: `.tmux/plugins/**`, `.zim/**`, `.local/share/nvim/**`

### Chezmoi File Naming Conventions
- `dot_` prefix → `.` (e.g., `dot_zshrc` → `.zshrc`)
- `private_` prefix → File created with 600 permissions
- `executable_` prefix → File created with executable permissions
- `.tmpl` suffix → Template file processed by Chezmoi
- `exact_` prefix → Directory contents managed exactly (removes extra files)

---

## Common Pitfalls & Solutions

### Working with Chezmoi Templates
**Problem**: Edited `~/.zshrc` directly but changes lost after `chezmoi apply`
**Solution**: Always edit via `chezmoi edit ~/.zshrc` or edit `private_dot_zshrc.tmpl` directly

**Problem**: Template syntax errors break config files
**Solution**: Test templates first with `chezmoi execute-template < file.tmpl`

### File Paths in Claude Code
**Important**: When working in this repository, always use absolute paths:
- ✅ `/Users/clay/.local/share/chezmoi/dot_config/nvim/init.lua`
- ❌ `dot_config/nvim/init.lua` (relative paths may fail)

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
1. **This is the source directory** - Files here are templates/sources, not the actual configs
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

# Update a secret in template
chezmoi edit ~/.zshrc
# Update the onepasswordRead path

# Add new tool via Homebrew
chezmoi edit ~/.Brewfile
# Add: brew "toolname"
chezmoi apply
brew bundle

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

### Git Status (as of repository init)
- **Current Branch**: main
- **Modified Files**: kitty config, nvim plugins, tmux, starship
- **Untracked**: New tmux themes, starship configs
- **Recent Focus**: Theme updates, font changes, C development support

### Active Development Areas
- Neovim plugin refinement (Overseer for C development)
- Terminal theme consistency (GitHub Dark across all tools)
- MCP server configuration and integration
- Shell prompt optimization (Starship configuration)

---

**Last Updated**: November 2024
**Maintained by**: Clay Coffman
**Repository**: https://github.com/clay-coffman/dotfiles.git