#!/bin/bash

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display a progress message
function progress_message {
    echo -e "${BLUE}==> $1${NC}"
}

# Function to display a success message
function success_message {
    echo -e "${GREEN}==> $1${NC}"
}

# Function to display an error message
function error_message {
    echo -e "${RED}==> $1${NC}"
}

# Function to display a warning message
function warning_message {
    echo -e "${YELLOW}==> $1${NC}"
}

# Update the system
progress_message "Updating the system..."
if sudo apt update && sudo apt upgrade -y; then
    success_message "System updated successfully."
else
    error_message "Failed to update the system."
fi

# Install useful command line tools
progress_message "Installing command line tools..."
if sudo apt install -y htop curl vim git net-tools; then
    success_message "Command line tools installed successfully."
else
    error_message "Failed to install command line tools."
fi

# Install Docker using the convenience script
progress_message "Downloading Docker installation script..."
if curl -fsSL https://get.docker.com -o get-docker.sh; then
    progress_message "Installing Docker..."
    if sudo sh get-docker.sh; then
        success_message "Docker installed successfully."
        rm get-docker.sh
    else
        error_message "Failed to install Docker."
    fi
else
    error_message "Failed to download Docker installation script."
fi

# Enable Docker to start on boot
progress_message "Enabling Docker to start on boot..."
if sudo systemctl enable docker; then
    success_message "Docker enabled to start on boot."
else
    error_message "Failed to enable Docker to start on boot."
fi

# Enable SSH login with password for all users
progress_message "Configuring SSH for password authentication..."
if sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
   sudo sed -i 's/^PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config && \
   sudo systemctl restart sshd; then
    success_message "SSH configured for password authentication."
else
    error_message "Failed to configure SSH."
fi

# Install Fish shell
progress_message "Installing Fish shell..."
if sudo apt install -y fish; then
    success_message "Fish shell installed successfully."
else
    error_message "Failed to install Fish shell."
fi

# Set Fish shell as default and configure greeting
progress_message "Setting Fish as default shell and configuring greeting..."
if chsh -s /usr/bin/fish && echo "set fish_greeting 'Emke'" | sudo tee -a /etc/fish/config.fish; then
    success_message "Fish shell set as default and greeting configured."
else
    error_message "Failed to set Fish as default shell or configure greeting."
fi

# Switch to Fish shell
progress_message "Switching to Fish shell..."
if exec fish; then
    success_message "Switched to Fish shell."
else
    error_message "Failed to switch to Fish shell."
fi

# Final message
success_message "System setup complete!"
warning_message "Please review the output above for any errors."

echo -e "${YELLOW}==> Rebooting the system is recommended to apply all changes.${NC}"
