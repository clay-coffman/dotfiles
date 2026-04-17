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

These dotfiles also deploy to my Hetzner box (`root@5.78.113.1`, hostname
`fedora-2gb-hil-1`) so SSH sessions match my local shell.

### What's templated per-host

Three files gate remote-specific behavior on
`(output "hostname" "-s" | trim)` — NOT `.chezmoi.hostname`, which
reverse-resolves to `localhost4` on that box due to its `/etc/hosts`:

- `private_dot_zshrc.tmpl` — skips `onepasswordRead` calls when the
  hostname matches the server (no `op` CLI there)
- `dot_tmux.conf.tmpl` — appends a red `REMOTE` badge to `status-left`
- `.chezmoiignore` — ignores GUI-only configs (kitty, ghostty, kwin,
  pipewire, raycast, aerospace, fontconfig, autostart, udev, fonts.conf,
  `run_onchange_install-udev-rules.sh.tmpl`)

### Visual "you are remote" indicators

- `dot_config/starship.toml` `[hostname]` is set to `ssh_only = true` +
  bold red — hostname segment appears only in SSH sessions.
- tmux status-left gets a red `REMOTE` block via the template guard
  above.

### Bootstrapping a fresh server

```bash
dnf -y install zsh tmux git fzf bat ripgrep zoxide neovim \
               ncurses-term util-linux-user fontconfig
curl -sS https://starship.rs/install.sh | sh -s -- -y
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
git clone --depth 1 https://github.com/z-shell/zi ~/.zi/bin
git clone --depth 1 https://github.com/tmux-plugins/tpm \
    ~/.config/tmux/plugins/tpm
chezmoi init --apply https://github.com/clay-coffman/dotfiles.git
chsh -s "$(command -v zsh)" "$USER"
# Inside tmux: prefix + I to install TPM plugins
```

### Adding a new remote host

Replace `"fedora-2gb-hil-1"` in the three template guards with the new
host's `hostname -s` output. If you want the same box to match multiple
names, swap `eq` → `has` / `or`.

### Known rough edges

- `sainnhe/tmux-fzf-url` (line in `dot_tmux.conf.tmpl`) fails to clone —
  the repo appears to have moved. Safe to remove or replace.
- `chezmoi doctor` on the hetzner box reports a `hardlink` error because
  `$HOME` and `/tmp` are on different filesystems. Harmless.
