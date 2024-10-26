#!/bin/bash

# Get the current username
USERNAME=$(whoami)

# Target .vimrc file for the current user
VIMRC_FILE="/home/$USERNAME/.vimrc"

# Check if .vimrc exists; if not, create it
if [ ! -f "$VIMRC_FILE" ]; then
    touch "$VIMRC_FILE"
    echo ".vimrc created for $USERNAME."
fi

# Add Vim configurations to .vimrc
echo "Configuring Vim with 'set number' and 'set wrap'..."

# Append the settings if they aren't already in .vimrc
grep -qxF 'set number' "$VIMRC_FILE" || echo 'set number' >> "$VIMRC_FILE"
grep -qxF 'set wrap' "$VIMRC_FILE" || echo 'set wrap' >> "$VIMRC_FILE"

echo "Vim configuration complete! The following settings have been applied to $VIMRC_FILE:"
echo " - set number (display line numbers)"
echo " - set wrap (wrap long lines)"

# Display the .vimrc file contents for verification
echo "Current .vimrc contents:"
cat "$VIMRC_FILE"
