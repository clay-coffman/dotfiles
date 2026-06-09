# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Chezmoi-managed dotfiles for Clay Coffman, targeting two daily-driver macOS MacBooks (one work, one personal) plus a couple of Fedora KDE/Wayland remote dev hosts.
Repository: https://github.com/clay-coffman/dotfiles.git (public)

## Critical Rule

**Never edit deployed files directly** (e.g., `~/.zshrc`, `~/.config/nvim/init.lua`).
Always edit the source files here in `~/.local/share/chezmoi/`, then run `chezmoi apply` to deploy.

## Machine detection

Per-machine values are derived at `chezmoi init` time by `.chezmoi.toml.tmpl`, which writes them to `~/.config/chezmoi/chezmoi.toml`. Detection is hostname-based: any short hostname listed in `workHosts` (in `.chezmoidata.yaml`) is treated as a work Mac; anything else is personal.

Available data fields:
- `.role` — `"work"` or `"personal"`
- `.work` — boolean, same info
- `.email` — `clay@carepilot.com` on work, `claymcoffman@gmail.com` on personal
- `.op_account` — `carepilot.1password.com` on work, `my.1password.com` on personal
- `.gh_user` — `clay-coffman` (single GitHub account, two verified emails)
- `.hostname` — short hostname

After hostname changes or onboarding a new work Mac, re-run `chezmoi init` to refresh the resolved data.

## 1Password routing

Default `onepasswordRead` calls use whichever 1P account is signed in. To pin a lookup to a specific account regardless of which Mac is rendering, pass the account as the second arg:

```
{{ onepasswordRead "op://Private/Context7 API Key/credential" "my.1password.com" }}
```

The work Mac has both `carepilot.1password.com` and `my.1password.com` signed in. The personal Mac will normally only need `my.1password.com`.

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

# Re-render .chezmoi.toml.tmpl after hostname or workHosts changes
chezmoi init

# Show resolved data (role, email, op_account, etc.)
chezmoi data

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
{{ .chezmoi.homeDir }}                                              // home directory
{{ .chezmoi.os }}                                                   // "darwin" or "linux"
{{ if eq .chezmoi.os "linux" }}...{{ end }}                          // OS conditional
{{ if eq .role "work" }}...{{ end }}                                 // machine-role conditional
{{ index .ssh_signing_keys .role }}                                  // pick a value by role
{{ onepasswordRead "op://vault/item/field" "my.1password.com" }}     // 1Password lookup, account-pinned
```

## Key Configs

- **Zsh**: `private_dot_zshrc.tmpl` — 1Password secrets pinned to personal account; OS-conditional blocks
- **Tmux**: `dot_tmux.conf.tmpl` — OS-conditional theme detection
- **Neovim**: `dot_config/nvim/` — LazyVim-based, plain Lua (not templated)
- **Ghostty**: `dot_config/ghostty/config` — primary terminal emulator
- **Git**: `private_dot_gitconfig.tmpl` — SSH signing via 1Password; per-machine signingkey from `ssh_signing_keys` map; work Mac adds HTTPS rewrite + `includeIf` for carepilot repos
- **Carepilot git override**: `private_dot_gitconfig.carepilot.tmpl` — separate SSH signing key for commits inside `~/Dev/carepilot/repos/`
- **SSH**: `private_dot_ssh/private_config.tmpl` — 1Password agent globally; alternate `github-personal-site` host for Linux deploy boxes
- **Aerospace**: `dot_config/aerospace/aerospace.toml` — i3-style alt bindings, JankyBorders for active-window indicator
- **Claude Code**: `dot_claude/settings.json.tmpl` + `dot_claude/executable_statusline-command.sh` + `dot_claude/hooks/executable_nvim-reload.sh` (PostToolUse → live-reloads the sibling-pane nvim) — synced; `settings.local.json` and runtime state stay per-machine (see `.chezmoiignore`)
- **Claude Code + Neovim diff-review workflow**: see [`docs/claude-nvim-workflow.md`](docs/claude-nvim-workflow.md) — the documented prompt → edit → review → revert loop across the tmux CC/nvim split, plus the keymap cheatsheet
- **Brewfile**: `dot_Brewfile` (base) + `dot_Brewfile.work` + `dot_Brewfile.personal`. `run_onchange_brew-bundle.sh.tmpl` applies both base and overlay on every change
- **KDE shortcuts**: `dot_config/private_kglobalshortcutsrc` (Linux remotes only)
- **KWin rules**: `dot_config/kwinrulesrc` (Linux remotes only)
- **Starship**: `dot_config/starship.toml.tmpl` — OS-aware palette

## Architecture Notes

- Templates (`.tmpl`) are the only files that need chezmoi rendering — plain config files are copied as-is
- 1Password integration means `chezmoi apply` requires the relevant 1P account to be signed in for any template that references secrets
- The `.chezmoiignore` excludes documentation, IDE configs, plugin data, secrets, and dynamic state files from management; it's a Go template too, so it can conditionally exclude per-host (`remoteHosts` paths skip macOS-only configs like `.config/aerospace` and `.config/ghostty`)
- Neovim plugins are managed by Lazy.nvim (not chezmoi) — `lazy-lock.json` is gitignored
- Tmux plugins are managed by TPM (not chezmoi) — `~/.tmux/plugins/` is gitignored
- Brewfile splits do NOT merge automatically; the run_onchange script runs base then overlay, and `brew bundle` only adds packages (doesn't uninstall), so removing from a Brewfile is a no-op until you `brew bundle cleanup` manually
