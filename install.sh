#!/bin/bash
cd ~/.dotfiles

# Only stow config packages
stow ai
stow asdf
stow btop
stow fastfetch
stow kitty
stow misc_configs
stow neovim
stow sketchybar
stow starship
stow spotify-player
stow tmux
stow yazi
stow zsh

echo "Dotfiles deployed!"
