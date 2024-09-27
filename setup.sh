#!/bin/bash

# Redirect stdout and stderr to a log file
exec > >(tee -i setup.log)
exec 2>&1

# Disable immediate exit on error
set +e

echo "Updating and upgrading packages..."
# Update and upgrade packages
sudo apt update -y

echo "Checking if swap setup is needed..."
# Create a swap file

# Default swap size in MB
DEFAULT_SWAP_SIZE=8192

# Check if swap setup is needed
setup_swap=${2:-"n"}

if [[ "$setup_swap" == "y" || "$setup_swap" == "Y" ]]; then
  echo "Setting up swap file..."
  # Get swap size from arguments or use default
  SWAP_SIZE=${1:-$DEFAULT_SWAP_SIZE}
  sudo truncate -s 0 /swapfile
  sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE status=progress
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
fi

echo "Installing necessary dependencies..."
# Install necessary dependencies
sudo apt install -y git build-essential ca-certificates curl

echo "Installing Docker..."
# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index..."
sudo apt-get update

echo "Installing Docker Engine..."
# Install Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Performing post-installation steps for Docker..."
# Post-installation steps
if ! getent group docker > /dev/null; then
  sudo groupadd docker
fi
# Add the current user to the docker group
echo "Adding the current user to the docker group..."
sudo usermod -aG docker $USER
# Activate the new group
echo "Activating the new group..."
newgrp docker

echo "Enabling Docker service..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Setup script completed. Please log out and log back in for Docker group changes to take effect."