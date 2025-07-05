#!/bin/bash

echo "🚀 Installing Docker on 64-bit Raspberry Pi OS..."

# Check architecture
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ]; then
  echo "⚠️ This script is for 64-bit Raspberry Pi OS only (aarch64). Your architecture is: $ARCH"
  exit 1
fi

# Update system
echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker
echo "🐋 Installing Docker..."
curl -fsSL https://get.docker.com  -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# Add user to docker group
echo "👤 Adding user 'pi' to docker group..."
sudo usermod -aG docker pi

# Enable Docker service
echo "⚙️ Enabling Docker service at boot..."
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose
echo "📦 Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="v2.23.0"
sudo curl -L "https://github.com/docker/compose/releases/download/ ${DOCKER_COMPOSE_VERSION}/docker-compose-linux-aarch64" \
-o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Installation
echo "✅ Verifying Docker and Docker Compose versions..."
docker --version
docker-compose --version

# Run test container
echo "🧪 Running hello-world container to verify Docker works..."
sudo docker run hello-world

echo "🎉 Docker and Docker Compose installed successfully!"
echo ""
echo "📌 You may need to log out and back in for group changes to take effect."
