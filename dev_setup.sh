#!/bin/bash

# Install Zsh
echo "Installing Zsh..."
if command -v apt &> /dev/null; then
    sudo apt install -y zsh
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm zsh
elif command -v dnf &> /dev/null; then
    sudo dnf install -y zsh
else
    echo "Unsupported package manager."
    exit 1
fi

# Set Zsh as default shell
chsh -s $(which zsh)
echo "Zsh installed and set as the default shell."

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Neovim and Visual Studio Code
echo "Installing Neovim and Visual Studio Code..."

if command -v apt &> /dev/null; then
    sudo apt install -y neovim
    sudo snap install code --classic
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm neovim
    sudo pacman -S --noconfirm visual-studio-code-bin
elif command -v dnf &> /dev/null; then
    sudo dnf install -y neovim
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf install -y code
else
    echo "Unsupported package manager."
    exit 1
fi

echo "Neovim and Visual Studio Code installed."

echo "Installing Node.js and npm..."

if command -v apt &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt install -y nodejs
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm nodejs npm
elif command -v dnf &> /dev/null; then
    sudo dnf install -y nodejs npm
else
    echo "Unsupported package manager."
    exit 1
fi

echo "Node.js and npm installed."

echo "Setting up Python Virtualenv..."

# Install virtualenv
if command -v apt &> /dev/null; then
    sudo apt install -y python3-venv
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm python-virtualenv
elif command -v dnf &> /dev/null; then
    sudo dnf install -y python3-virtualenv
else
    echo "Unsupported package manager."
    exit 1
fi

echo "Python Virtualenv setup complete. Use 'python3 -m venv <env_name>' to create a virtual environment."
