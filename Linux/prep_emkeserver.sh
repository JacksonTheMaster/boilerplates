#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Install useful command line tools
sudo apt install -y htop curl vim git net-tools

# Install Docker using the convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Enable SSH login with password for all users
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "System update, tool installation, Docker setup, and SSH configuration complete."
