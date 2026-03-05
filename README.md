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
