#!/usr/bin/env bash
# Theme switcher for macOS dark/light mode
# Automatically switches themes for: kitty, nvim, tmux, starship

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Detect macOS appearance
detect_macos_theme() {
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
        echo "dark"
    else
        echo "light"
    fi
}

# Kitty theme switching is handled automatically by kitty itself
# using the ${KITTY_OS_DARK_MODE} variable in kitty.conf

# Switch Neovim theme
switch_nvim_theme() {
    local theme=$1
    local nvim_theme_file="$CONFIG_DIR/nvim/current-theme.lua"
    
    if [ "$theme" = "dark" ]; then
        echo 'vim.g.catppuccin_flavor = "macchiato"' > "$nvim_theme_file"
        echo 'vim.cmd.colorscheme("catppuccin-macchiato")' >> "$nvim_theme_file"
    else
        echo 'vim.g.catppuccin_flavor = "latte"' > "$nvim_theme_file"
        echo 'vim.cmd.colorscheme("catppuccin-latte")' >> "$nvim_theme_file"
    fi
    
    # Send reload command to all running nvim instances
    for server in $(nvim --headless --cmd 'echo join(serverlist(), "\n")' +q 2>/dev/null); do
        nvim --server "$server" --remote-send ':source $HOME/.config/nvim/current-theme.lua<CR>' 2>/dev/null || true
    done
}

# Switch tmux theme
switch_tmux_theme() {
    local theme=$1
    local tmux_theme_file="$HOME/.tmux-theme.conf"
    
    if [ "$theme" = "dark" ]; then
        echo 'set -g @catppuccin_flavor "macchiato"' > "$tmux_theme_file"
    else
        echo 'set -g @catppuccin_flavor "latte"' > "$tmux_theme_file"
    fi
    
    # Reload tmux if running
    if tmux info &>/dev/null; then
        tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
        # Force catppuccin plugin to reload with new theme
        tmux run-shell "$HOME/.tmux/plugins/tmux/catppuccin.tmux" 2>/dev/null || true
    fi
}

# Switch Starship theme
switch_starship_theme() {
    local theme=$1
    local starship_config="$DOTFILES_DIR/starship.toml"
    local temp_file=$(mktemp)
    
    if [ "$theme" = "dark" ]; then
        sed "s/palette = 'catppuccin_latte'/palette = 'catppuccin_macchiato'/" "$starship_config" > "$temp_file"
    else
        sed "s/palette = 'catppuccin_macchiato'/palette = 'catppuccin_latte'/" "$starship_config" > "$temp_file"
    fi
    
    mv "$temp_file" "$starship_config"
}

# Save current theme to file for persistence
save_theme_state() {
    local theme=$1
    echo "$theme" > "$HOME/.current-theme"
}

# Main function
main() {
    local current_theme=$(detect_macos_theme)
    local previous_theme=""
    
    # Read previous theme if exists
    if [ -f "$HOME/.current-theme" ]; then
        previous_theme=$(cat "$HOME/.current-theme")
    fi
    
    # Only switch if theme has changed or forced
    if [ "$current_theme" != "$previous_theme" ] || [ "$1" = "--force" ]; then
        echo "Switching to $current_theme mode..."
        
        switch_nvim_theme "$current_theme"
        switch_tmux_theme "$current_theme"
        switch_starship_theme "$current_theme"
        
        save_theme_state "$current_theme"
        
        echo "Theme switched to $current_theme mode"
    fi
}

# Run main function
main "$@"
