#!/bin/bash

# Disable immediate exit on error
set +e

# Update and upgrade packages
sudo apt update -y

# Install necessary dependencies
sudo apt install -y git build-essential

# Install Docker

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Post-installation steps
if ! getent group docker > /dev/null; then
  sudo groupadd docker
fi
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Create a swap file

# Default swap size in MB
DEFAULT_SWAP_SIZE=8192

# Check if swap setup is needed
read -p "Do you want to setup swap? (y/n): " setup_swap
if [[ "$setup_swap" == "y" || "$setup_swap" == "Y" ]]; then
  # Get swap size from arguments or use default
  SWAP_SIZE=${1:-$DEFAULT_SWAP_SIZE}
  sudo truncate -s 0 /swapfile
  sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE status=progress
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
fi