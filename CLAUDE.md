# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Chezmoi-managed dotfiles for a Fedora Linux (KDE Plasma/Wayland) development environment.
Repository: https://github.com/clay-coffman/dotfiles.git

## Critical Rule

**Never edit deployed files directly** (e.g., `~/.zshrc`, `~/.config/nvim/init.lua`).
Always edit the source files here in `~/.local/share/chezmoi/`, then run `chezmoi apply` to deploy.

## Chezmoi File Naming

| Prefix/Suffix | Meaning | Example |
|---|---|---|
| `dot_` | Becomes `.` | `dot_zshrc` → `.zshrc` |
| `private_` | 600 permissions | `private_dot_zshrc.tmpl` |
| `executable_` | Executable bit set | `executable_merge-claude-config.sh` |
| `.tmpl` | Go template, rendered by chezmoi | `dot_tmux.conf.tmpl` |
| `exact_` | Directory contents managed exactly | |

## Essential Commands

```bash
# Preview what chezmoi would change
chezmoi diff

# Apply changes to the system
chezmoi apply

# Apply with verbose output
chezmoi apply --verbose

# Test template rendering
chezmoi execute-template < some_file.tmpl

# Find the source file for a deployed config
chezmoi source-path ~/.config/ghostty/config

# Add a new file to chezmoi management
chezmoi add ~/.config/some-tool/config
```

## Template Syntax (Go templates)

Files ending in `.tmpl` use Go template syntax with chezmoi extensions:

```go
{{ .chezmoi.homeDir }}                                    // home directory
{{ .chezmoi.os }}                                         // "darwin" or "linux"
{{ if eq .chezmoi.os "linux" }}...{{ end }}                // OS conditional
{{ onepasswordRead "op://vault/item/field" }}              // 1Password secret
```

## Key Configs

- **Zsh**: `private_dot_zshrc.tmpl` — template with 1Password secrets, OS-conditional blocks
- **Tmux**: `dot_tmux.conf.tmpl` — template with OS-conditional theme detection
- **Neovim**: `dot_config/nvim/` — LazyVim-based, plain Lua (not templated)
- **Ghostty**: `dot_config/ghostty/config` — primary terminal emulator
- **Git**: `private_dot_gitconfig` — SSH signing via 1Password
- **KDE shortcuts**: `dot_config/private_kglobalshortcutsrc`
- **KWin rules**: `dot_config/kwinrulesrc`
- **Starship**: `dot_config/starship.toml` — shell prompt

## Architecture Notes

- Templates (`.tmpl`) are the only files that need chezmoi rendering — plain config files are copied as-is
- 1Password integration means `chezmoi apply` requires `op signin` for template files that reference secrets
- The `.chezmoiignore` excludes documentation, IDE configs, plugin data, secrets, and dynamic state files from management
- Neovim plugins are managed by Lazy.nvim (not chezmoi) — `lazy-lock.json` is gitignored
- Tmux plugins are managed by TPM (not chezmoi) — `~/.tmux/plugins/` is gitignored
