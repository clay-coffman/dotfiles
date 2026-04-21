## My dotfiles

Used to work on os x but recently switched to fedora and not sure if they still
work on mac

### One-liner Installation

Install these dotfiles on a new machine with a single command via chezmoi:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply clay-coffman
```

Already have chezmoi installed:

```bash
chezmoi init --apply https://github.com/clay-coffman/dotfiles.git
```

## Tools/configs

### Shell and terminal

I spend most of my time in/using:

- tmux + some tpm plugins
- kitty
- neovim
- zsh + zinit + starship prompt

### PipeWire

- `~/.config/pipewire/pipewire.conf.d/50-disable-raop.conf` disables the AirPlay/RAOP discovery module. Without this, PipeWire discovers every AirPlay device on the network (dozens of MacBooks on an office network), creates sinks for all of them, spams `mod.raop-sink` errors, and balloons to 500MB+ of memory. This can cause WirePlumber to crash-loop and media playback (YouTube, Spotify) to stop working.

### other tools

other tools i use a lot

- chezmoi
- 1pass cli for secrets
- btop
- yazi
- other stuff like rg, fzf, atuin, etc

## Remote server support

These dotfiles also deploy to my Hetzner + homelab servers so SSH
sessions match my local shell.

### What's templated per-host

Remote hosts are listed in `.chezmoidata.yaml` under `remoteHosts`.
Three files gate remote-specific behavior on membership in that list
(via `has (output "hostname" "-s" | trim) .remoteHosts`) — NOT
`.chezmoi.hostname`, which reverse-resolves to `localhost4` on Hetzner
boxes due to their `/etc/hosts`:

- `private_dot_zshrc.tmpl` — skips `onepasswordRead` calls on remotes
  (no `op` CLI there)
- `dot_tmux.conf.tmpl` — appends a red `REMOTE` badge to `status-left`
- `.chezmoiignore` — ignores GUI-only configs (kitty, ghostty, kwin,
  pipewire, raycast, aerospace, fontconfig, autostart, udev, fonts.conf,
  `run_onchange_install-udev-rules.sh.tmpl`)

### Visual "you are remote" indicators

- `dot_config/starship.toml` `[hostname]` is set to `ssh_only = true` +
  bold red — hostname segment appears only in SSH sessions.
- tmux status-left gets a red `REMOTE` block via the template guard
  above.

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

- **TPM** is cloned automatically by `run_once_install-tpm.sh` during
  `chezmoi apply`. Inside tmux press `prefix + I` to install plugins.
- **`entr`** is now in the package list (needed for `tmux-autoreload`).
- **Ghostty terminfo**: Ghostty's `xterm-ghostty` terminfo is usually
  absent on a fresh Fedora box. Without it `tmux attach` errors with
  "missing or unsuitable terminal" and backspace misbehaves over SSH.
  From your **local** workstation (any Ghostty session), push it:
  ```bash
  infocmp -x xterm-ghostty | ssh NEW_HOST 'tic -x -'
  ```

### Adding a new remote host

Append the new host's `hostname -s` output to `remoteHosts` in
`.chezmoidata.yaml`. No other template edits needed.

### Known rough edges

- `chezmoi doctor` on the Hetzner box reports a `hardlink` error because
  `$HOME` and `/tmp` are on different filesystems. Harmless.
