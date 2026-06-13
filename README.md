# My dotfiles

chezmoi-managed dotfiles for my small fleet. macOS is the daily driver (a work
and a personal MacBook Air), with a Fedora server in the mix and a Fedora KDE
desktop config kept around for when I want it. One source of truth, rendered
per-machine via Go templates at `chezmoi apply` time.

## The fleet

| Machine | Hostname | Role | Notes |
|---|---|---|---|
| Work MacBook Air | `Clays-MacBook-Air` | `work` | CarePilot day-job machine; signs work commits with a separate key, work 1Password account |
| Personal MacBook Air | `Clays-Personal-MacBook-Air` | `personal` | this machine; `my.1password.com` |
| Hetzner server | `cloud-hil-1` | remote (Fedora) | self-hosting box + the **sync hub** (see below); headless, no `op` CLI |
| ThinkPad *(retired)* | — | remote (Fedora KDE) | deprecated, but its KDE/Plasma/Wayland configs stay in the repo in case I go back |

**Role detection** happens at `chezmoi init` in `.chezmoi.toml.tmpl`, keyed off
`hostname -s`:

- hostname in `workHosts` (`.chezmoidata.yaml`) → `role = work` (work email + work
  1Password account + carepilot commit-signing override)
- hostname in `remoteHosts` → headless-Linux treatment: skip macOS GUI configs, skip
  `onepasswordRead`, skip commit signing, add "remote" indicators
- otherwise → `role = personal`

## Cross-machine sync

The two Macs stay in sync automatically through a **private git hub** on `cloud-hil-1`
(a bare repo at `/home/git/chezmoi.git`, added as the git remote `hub`). I kept
forgetting to commit/push/pull, so now a background job does it. The **public GitHub
repo is never auto-pushed** — publishing there is a separate, deliberate step.

- **`chezmoi-sync`** (`dot_local/bin/`) runs every 30 min and at login via launchd
  (`com.clay.chezmoi-sync`): commit local edits (unsigned) → rebase onto `hub/main` →
  push to `hub` → best-effort `chezmoi apply`. It only ever talks to `hub`, never to
  the public repo, so its blast radius is my own server. On a rebase conflict it aborts
  and notifies (resolve by hand in `~/.local/share/chezmoi`, then re-run). Logs to
  `~/Library/Logs/chezmoi-sync.log`.
- **`dotfiles-publish`** is the *only* path to the public GitHub repo: it fetches, shows
  the `origin/main..HEAD` diff, runs a fail-closed **gitleaks** secret scan, prompts,
  then does a **signed** push.
- **`dotfiles-publish-check`** + `com.clay.dotfiles-publish-nudge` (weekly) fire a
  notification when the hub is ahead of the public repo, so I don't forget to publish.
- **Auth:** a dedicated passphrase-less key (`~/.ssh/chezmoi_sync_ed25519`, per-machine,
  untracked) reaches the hub via the `chezmoi-hub` SSH alias — *not* the 1Password agent,
  so the unattended timer never trips an unlock prompt. On the hub it logs in as a
  `git-shell`-locked `git` user authorized with `restrict`, so the key can only sync this
  one repo and can't push to GitHub.

Deep details: [`CLAUDE.md`](CLAUDE.md) (this repo) and `~/Dev/hetzner/SERVER.md` (hub server).

## Install / onboard a machine

Fresh machine, no chezmoi yet:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply clay-coffman
```

Already have chezmoi:

```bash
chezmoi init --apply https://github.com/clay-coffman/dotfiles.git
```

**macOS prerequisites:** install/enable 1Password and turn on **Settings → Developer →
"Use the SSH agent"** *and* **"Integrate with 1Password CLI"** — `chezmoi apply` needs the
CLI to read secrets (`onepasswordRead`) and `op-ssh-sign` to sign commits.

**Join the sync loop:** on first `chezmoi apply`, `run_once_after_bootstrap-chezmoi-sync.sh`
generates this machine's automation key, adds the `hub` remote, and prints a one-time
`authorized_keys` command to run as root on `cloud-hil-1`. Run it and the launchd timers
take over. (Server-side hub setup is in `~/Dev/hetzner/SERVER.md`.)

## Tools / configs

The stack I actually live in:

- **Shell:** zsh + [Zi](https://github.com/z-shell/zi) (plugin manager) + **starship**
  prompt + **atuin** history + vi-mode; `direnv`, `zoxide`
- **Terminal:** **ghostty** (primary), kitty (fallback config)
- **Editor:** neovim, **LazyVim**-based (`dot_config/nvim/`, plain Lua, not templated)
- **Multiplexer:** tmux, prefix `Ctrl + a` (see `dot_tmux.conf.tmpl`)
- **Window manager (macOS):** [aerospace](https://github.com/nikitabobko/AeroSpace) (i3-style
  alt bindings) + `borders` (JankyBorders) for an active-window indicator
- **Files / git / misc:** yazi, lazygit, bat, ripgrep, fd, fzf
- **Runtimes:** **asdf**, pinned in `dot_tool-versions` (Go, Node, Ruby, Rust, Lua, Python)
- **Packages (macOS):** **Brewfile** splits — `dot_Brewfile` (base) + `dot_Brewfile.work`
  / `dot_Brewfile.personal` overlay, applied by `run_onchange_brew-bundle.sh`
- **Secrets & signing:** 1Password — secrets pulled with `onepasswordRead` (account-pinned),
  commits SSH-signed via `op-ssh-sign`
- **Claude Code:** `dot_claude/settings.json` + statusline synced across machines

## Linux desktop (KDE / Plasma)

> Targets a Fedora KDE/Wayland desktop. That's currently the **retired ThinkPad** — these
> configs stay in the repo, dormant, for when I run a Linux desktop again.

KDE Plasma global shortcuts live in `dot_config/private_kglobalshortcutsrc`. The scheme is
**vim keys for everything directional**, with the modifier telling you what kind of action:

| Combo | Meaning |
|---|---|
| `Meta + h/j/k/l` | **Focus** a window in that direction (crosses screen boundaries) |
| `Meta + Shift + h/j/k/l` | **Move** active window between screens in that direction |
| `Meta + Ctrl + h/j/k/l` | **Tile** active window to that half (left/right/top/bottom) |
| `Meta + Ctrl + Return` | Maximize / restore |
| `Meta + Alt + h` / `Meta + Alt + l` | Previous / next activity |
| `Alt + 1` / `Alt + 2` / `Alt + 3` | Jump directly to activity (Random/Personal, Dev, School) |

No arrow keys are bound for window/activity ops — vim keys only. Virtual desktops are not
used; activities only.

### Window cycling and apps

| Combo | Action |
|---|---|
| `Alt + Tab` / `Alt + Shift + Tab` | Cycle through windows |
| `` Meta + ` `` / `Meta + ~` | Cycle windows of current app |
| `Meta + 1..9` | Activate task manager entry N |
| `Meta` (tap) | Application launcher |
| `Meta + Q` | Activity switcher |
| `Meta + W` | Overview |
| `Meta + G` | Grid view |
| `Meta + D` | Peek at desktop |
| `Meta + T` | Tiles editor |

### Capture, clipboard, system

| Combo | Action |
|---|---|
| `Meta + Shift + Print` | Rectangular region screenshot |
| `Meta + Ctrl + Print` | Window-under-cursor screenshot |
| `Meta + V` | Show clipboard items at mouse |
| `Meta + Ctrl + X` | Automatic clipboard action popup |
| `Ctrl + Alt + L` | Lock session |
| `Ctrl + Alt + Del` | Logout screen |
| `Meta + Ctrl + Esc` | Kill window |
| `Meta + Shift + Esc` | Disable active input capture |
| `Alt + F4` | Close window |
| `Alt + F3` | Window operations menu |

### Expose / present windows

| Combo | Action |
|---|---|
| `Ctrl + F9` | Present windows (current activity) |
| `Ctrl + F10` | Present windows (all activities) |
| `Ctrl + F7` | Present windows (window class) |

### Custom service shortcuts

Wired up via `[services][...]` entries in `kglobalshortcutsrc`:

| Combo | Action |
|---|---|
| `Meta + Esc` | Dismiss notifications (`net.local.dismiss-notifications.sh`) |
| `Meta + ?` | Open shortcuts cheatsheet |
| `Meta + Shift + T` | Toggle Plasma theme (light/dark) |
| `F3` / `F4` | Brightness down / up |

### XKB layout tweaks

Set in `dot_config/kxkbrc`:

- **`caps:swapescape`** — Caps Lock and Escape are swapped
- **`altwin:meta_win`** — Win key acts as Meta

### PipeWire

- `~/.config/pipewire/pipewire.conf.d/50-disable-raop.conf` disables the AirPlay/RAOP
  discovery module. Without this, PipeWire discovers every AirPlay device on the network
  (dozens of MacBooks on an office network), creates sinks for all of them, spams
  `mod.raop-sink` errors, and balloons to 500MB+ of memory. This can cause WirePlumber to
  crash-loop and media playback (YouTube, Spotify) to stop working.

## Fedora server (`cloud-hil-1`)

These dotfiles also deploy to my Hetzner server so SSH sessions match my local shell.

### What's templated per-host

Remote hosts are listed in `.chezmoidata.yaml` under `remoteHosts`. A few files gate
remote-specific behavior on membership in that list (via
`has (output "hostname" "-s" | trim) .remoteHosts`) — NOT `.chezmoi.hostname`, which
reverse-resolves to `localhost4` on the Hetzner box due to its `/etc/hosts`:

- `private_dot_zshrc.tmpl` — skips `onepasswordRead` calls on remotes (no `op` CLI there)
- `dot_tmux.conf.tmpl` — appends a red `REMOTE` badge to `status-left`
- `.chezmoiignore` — ignores GUI-only configs (kitty, ghostty, kwin, pipewire, raycast,
  aerospace, fontconfig, autostart, udev, fonts.conf, the launchd agents, and
  `run_onchange_install-udev-rules.sh.tmpl`)

### Visual "you are remote" indicators

- `dot_config/starship.toml` `[hostname]` is `ssh_only = true` + bold red — the hostname
  segment appears only in SSH sessions.
- tmux `status-left` gets a red `REMOTE` block via the template guard above.

### Bootstrapping a fresh Fedora server

Run on the new server:

```bash
dnf -y install zsh tmux git fzf bat ripgrep zoxide neovim \
               ncurses-term util-linux-user fontconfig entr
curl -sS https://starship.rs/install.sh | sh -s -- -y
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
git clone --depth 1 https://github.com/z-shell/zi ~/.zi/bin
chezmoi init --apply https://github.com/clay-coffman/dotfiles.git
chsh -s "$(command -v zsh)" "$USER"
```

Notes:

- **TPM** is cloned automatically by `run_once_install-tpm.sh` during `chezmoi apply`.
  Inside tmux press `prefix + I` to install plugins.
- **`entr`** is in the package list (needed for `tmux-autoreload`).
- **Ghostty terminfo**: Ghostty's `xterm-ghostty` terminfo is usually absent on a fresh
  Fedora box. Without it `tmux attach` errors with "missing or unsuitable terminal" and
  backspace misbehaves over SSH. From your **local** workstation (any Ghostty session),
  push it:
  ```bash
  infocmp -x xterm-ghostty | ssh NEW_HOST 'tic -x -'
  ```

### Adding a new remote host

Append the new host's `hostname -s` output to `remoteHosts` in `.chezmoidata.yaml`. No
other template edits needed.

### Known rough edges

- `chezmoi doctor` on the Hetzner box reports a `hardlink` error because `$HOME` and `/tmp`
  are on different filesystems. Harmless.

## More docs

- [`CLAUDE.md`](CLAUDE.md) — the working reference for editing this repo (machine detection,
  templating, 1Password routing, the sync system, key configs)
- [`GIT_TOOLS.md`](GIT_TOOLS.md) — git/GitHub workflow tooling
- `~/Dev/hetzner/SERVER.md` — the `cloud-hil-1` server (Coolify, services, and the sync hub)
