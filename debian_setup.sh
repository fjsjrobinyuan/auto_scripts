#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Prompt for the username
read -p "Enter the username to add to sudoers: " USERNAME

# Verify the user exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' found."

    # Add the user to sudoers if not already
    if ! grep -q "^$USERNAME " /etc/sudoers; then
        echo "$USERNAME ALL=(ALL:ALL) ALL" >> /etc/sudoers
        echo "User '$USERNAME' added to sudoers."
    else
        echo "User '$USERNAME' is already in the sudoers file."
    fi
else
    echo "User '$USERNAME' does not exist. Please create the user first."
    exit 1
fi

# Update and Upgrade
echo "Updating and upgrading the system..."
apt update && apt upgrade -y

# Install Essential Packages
echo "Installing essential packages..."
apt install -y build-essential curl wget git vim ufw htop

# Install Development Tools (adjust based on your needs)
echo "Installing development tools..."
apt install -y python3 python3-pip cmake gdb valgrind

# Install GUI Utilities (if desktop environment is installed)
echo "Installing GUI utilities..."
apt install -y gnome-terminal xfce4-terminal filezilla vlc

# Set Up Firewall with UFW
echo "Setting up the firewall..."
ufw allow OpenSSH
ufw enable

# Create Custom Directories
echo "Creating directories for projects and documents..."
su - "$USERNAME" -c 'mkdir -p ~/Projects ~/Documents ~/Downloads'

# Set Custom Bash Aliases
echo "Setting up bash aliases..."
su - "$USERNAME" -c 'cat <<EOL >> ~/.bash_aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
EOL'

# Configure Git (if needed)
echo "Configuring Git..."
su - "$USERNAME" -c 'git config --global user.name "Your Name"'
su - "$USERNAME" -c 'git config --global user.email "your.email@example.com"'
su - "$USERNAME" -c 'git config --global core.editor vim'

# Cleanup
echo "Cleaning up unnecessary packages..."
apt autoremove -y

# Final Message
echo "Initialization complete! Please reboot the system to apply changes."


# Prompt for the username
read -p "Enter the username to add to sudoers: " USERNAME

# Verify the user exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' found."

    # Add the user to sudoers if not already
    if ! grep -q "^$USERNAME " /etc/sudoers; then
        echo "$USERNAME ALL=(ALL:ALL) ALL" >> /etc/sudoers
        echo "User '$USERNAME' added to sudoers."
    else
        echo "User '$USERNAME' is already in the sudoers file."
    fi
else
    echo "User '$USERNAME' does not exist. Please create the user first."
    exit 1
fi

# Update and Upgrade
echo "Updating and upgrading the system..."
apt update && apt upgrade -y

# Install Essential Packages
echo "Installing essential packages..."
apt install -y build-essential curl wget git vim ufw htop

# Install Development Tools (adjust based on your needs)
echo "Installing development tools..."
apt install -y python3 python3-pip cmake gdb valgrind

# Install GUI Utilities (if desktop environment is installed)
echo "Installing GUI utilities..."
apt install -y gnome-terminal xfce4-terminal filezilla vlc

# Set Up Firewall with UFW
echo "Setting up the firewall..."
ufw allow OpenSSH
ufw enable

# Create Custom Directories
echo "Creating directories for projects and documents..."
su - "$USERNAME" -c 'mkdir -p ~/Projects ~/Documents ~/Downloads'

# Set Custom Bash Aliases
echo "Setting up bash aliases..."
su - "$USERNAME" -c 'cat <<EOL >> ~/.bash_aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
EOL'

# Configure Git (if needed)
echo "Configuring Git..."
su - "$USERNAME" -c 'git config --global user.name "Your Name"'
su - "$USERNAME" -c 'git config --global user.email "your.email@example.com"'
su - "$USERNAME" -c 'git config --global core.editor vim'

# Cleanup
echo "Cleaning up unnecessary packages..."
apt autoremove -y

# Final Message
echo "Initialization complete! Please reboot the system to apply changes."
