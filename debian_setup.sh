#!/bin/bash

# Start time
start_time=$(date +%s)

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

# Set the source file and desired output name
SOURCE_FILE="cli_helper_tool.c"
OUTPUT_NAME="cli_tools"

# Compile the C code
echo "Compiling $SOURCE_FILE..."
gcc -o "$OUTPUT_NAME" "$SOURCE_FILE"
if [ $? -ne 0 ]; then
    echo "Compilation failed. Please check for errors in $SOURCE_FILE."
    exit 1
fi
echo "Compilation successful."

# Check if /usr/local/bin is writable; if not, use ~/bin
INSTALL_DIR="/usr/local/bin"
if [ ! -w "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/bin"
    mkdir -p "$INSTALL_DIR"
    echo "$INSTALL_DIR created for user installation."
fi

# Move the executable to the installation directory
echo "Moving $OUTPUT_NAME to $INSTALL_DIR..."
mv "$OUTPUT_NAME" "$INSTALL_DIR/"
if [ $? -ne 0 ]; then
    echo "Failed to move $OUTPUT_NAME to $INSTALL_DIR."
    exit 1
fi

# Ensure INSTALL_DIR is in PATH if using ~/bin
if [[ "$INSTALL_DIR" == "$HOME/bin" ]]; then
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
        echo "$HOME/bin added to PATH in .bashrc. Please restart your terminal or run 'source ~/.bashrc' to apply changes."
    else
        echo "$HOME/bin is already in PATH."
    fi
fi

echo "You can now use '$OUTPUT_NAME' as a command."

# End time and calculate total time taken
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
echo "Total time taken: $elapsed seconds."

# Final message
echo "Setup is complete! It is recommended to reboot the system."
