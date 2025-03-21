#!/bin/bash

# Create the books directory if it doesn't exist
mkdir -p ~/books

# Copy all directories from current location to ~/books
# -r for recursive copy
# */ matches only directories
cp -r */ ~/books/

# Print success message
echo "Directories have been copied to ~/books/"
