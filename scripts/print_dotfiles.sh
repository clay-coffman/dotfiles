#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles/nvim"
OUTPUT_FILE="$HOME/.dotfiles/scripts/output/dotfiles_combined.txt"

# Iterate and append file paths and their content
find "$DOTFILES_DIR" -type f | while read -r file; do
    echo "File: ${file#$DOTFILES_DIR/}" >> "$OUTPUT_FILE"
    echo "$(printf '%0.s-' {1..60})" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n\n" >> "$OUTPUT_FILE"
done

echo "Dotfiles combined into $OUTPUT_FILE"
