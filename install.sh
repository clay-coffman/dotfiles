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
stow starship
stow tmux
stow yazi
stow zsh

echo "Dotfiles deployed!"
