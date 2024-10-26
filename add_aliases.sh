#!/bin/bash

echo "Adding common aliases to ~/.bashrc..."

cat <<EOL >> ~/.bashrc

# Custom Aliases
alias ll='ls -alF'
alias gs='git status'
alias gp='git pull'
alias gd='git diff'
EOL

echo "Common aliases added to ~/.bashrc. Please restart the terminal or run 'source ~/.bashrc' to apply."
