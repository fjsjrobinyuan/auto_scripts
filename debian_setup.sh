#!/bin/bash

# Get the current username
USERNAME=$(whoami)

# Check if the script is being run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root to complete the setup."
    echo "Usage: sudo $0"
    exit 1
fi

# Check if the current user is in the sudoers file
if ! sudo -l -U "$USERNAME" &>/dev/null; then
    echo "Adding $USERNAME to sudoers..."
    echo "$USERNAME ALL=(ALL:ALL) ALL" >> /etc/sudoers
    echo "User '$USERNAME' has been added to sudoers."
fi

# Update and Upgrade the system
echo "Updating and upgrading the system..."
apt update && apt upgrade -y

# Install essential packages
echo "Installing essential packages..."
apt install -y build-essential curl wget git vim ed nano python3 python3-pip python-is-python3

# Configure Git (prompt for user input)
read -p "Enter your Git username: " GIT_USERNAME
read -p "Enter your Git email: " GIT_EMAIL

echo "Configuring Git..."
su - "$USERNAME" -c "git config --global user.name \"$GIT_USERNAME\""
su - "$USERNAME" -c "git config --global user.email \"$GIT_EMAIL\""
su - "$USERNAME" -c "git config --global core.editor vim"

# Clean up unnecessary packages
echo "Cleaning up unnecessary packages..."
apt autoremove -y

# Final message
echo "Setup is complete! It is recommended to reboot the system."
