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

### other tools

other tools i use a lot

- chezmoi
- 1pass cli for secrets
- btop
- yazi
- other stuff like rg, fzf, atuin, etc
