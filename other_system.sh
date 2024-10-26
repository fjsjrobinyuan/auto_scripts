#!/bin/bash

echo "Configuring Docker for non-root access..."

# Add user to Docker group
sudo usermod -aG docker $USER

# Start Docker service if not running
if ! systemctl is-active --quiet docker; then
    sudo systemctl start docker
    sudo systemctl enable docker
fi

echo "Docker configured for non-root access. Please log out and log back in for changes to take effect."

echo "Configuring Tmux with basic settings..."

cat <<EOL > ~/.tmux.conf
# Enable mouse support
set -g mouse on

# Reload Tmux configuration
bind r source-file ~/.tmux.conf
EOL

echo "Tmux configuration complete! Use 'tmux' to start a new session."


echo "Installing system monitoring tools..."

if command -v apt &> /dev/null; then
    sudo apt install -y sysstat glances
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm sysstat glances
elif command -v dnf &> /dev/null; then
    sudo dnf install -y sysstat glances
else
    echo "Unsupported package manager."
    exit 1
fi

echo "System monitoring tools installed. Use 'glances' or 'iostat' to monitor system performance."

BACKUP_DIR="$HOME/config_backup"
echo "Creating backup directory at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Backup important configuration files
echo "Backing up key configuration files to $BACKUP_DIR..."
cp ~/.vimrc "$BACKUP_DIR/vimrc_backup"
cp ~/.bashrc "$BACKUP_DIR/bashrc_backup"
cp ~/.zshrc "$BACKUP_DIR/zshrc_backup" 2>/dev/null || echo ".zshrc not found, skipping."
cp ~/.tmux.conf "$BACKUP_DIR/tmux.conf_backup" 2>/dev/null || echo ".tmux.conf not found, skipping."

echo "Configuration files backed up to $BACKUP_DIR."

echo "Adding Git branch information to the shell prompt..."

# Add to .bashrc or .zshrc based on the shell
if [[ "$SHELL" == *"zsh"* ]]; then
    RC_FILE="$HOME/.zshrc"
else
    RC_FILE="$HOME/.bashrc"
fi

# Add prompt configuration
cat <<'EOL' >> "$RC_FILE"

# Custom Prompt with Git Branch
parse_git_branch() {
  git branch 2>/dev/null | grep '*' | sed 's/* //'
}

export PS1="\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[36m\]\$(parse_git_branch) \[\e[0m\]\$ "
EOL

echo "Prompt configured with Git branch information. Please restart your terminal or source $RC_FILE to apply."
