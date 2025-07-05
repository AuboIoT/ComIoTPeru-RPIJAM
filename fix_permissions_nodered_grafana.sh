#!/bin/bash

echo "🔧 Fixing permissions for Node-RED and Grafana directories in current path..."

# Use current working directory
BASE_DIR=$(pwd)

# Define expected paths
NR_DATA_DIR="$BASE_DIR/nodered/data"
GRAFANA_DATA_DIR="$BASE_DIR/grafana"

# UID/GID used by containers
CONTAINER_UID=472   # Grafana official image uses this UID
CONTAINER_GID=472

# Check if directories exist
if [ ! -d "$NR_DATA_DIR" ]; then
  echo "📁 Creating missing Node-RED data directory..."
  mkdir -p "$NR_DATA_DIR"
fi

if [ ! -d "$GRAFANA_DATA_DIR" ]; then
  echo "📁 Creating missing Grafana data directory..."
  mkdir -p "$GRAFANA_DATA_DIR"
fi

# Create necessary subfolders Grafana expects
mkdir -p "$GRAFANA_DATA_DIR"/{alerting,plugins,png,csv}

# Set ownership recursively
echo "👤 Setting ownership recursively to UID: $CONTAINER_UID and GID: $CONTAINER_GID..."
sudo chown -R $CONTAINER_UID:$CONTAINER_GID "$NR_DATA_DIR" "$GRAFANA_DATA_DIR"

# Set proper permissions
echo "🔐 Setting proper permissions recursively..."
sudo find "$NR_DATA_DIR" -type d -exec chmod 755 {} \;
sudo find "$GRAFANA_DATA_DIR" -type d -exec chmod 755 {} \;

sudo find "$NR_DATA_DIR" -type f -exec chmod 644 {} \;
sudo find "$GRAFANA_DATA_DIR" -type f -exec chmod 644 {} \;

# Tighten SQLite DB permissions
echo "🔒 Fixing SQLite DB permissions..."
find "$GRAFANA_DATA_DIR" -name "*.db" -exec chmod 600 {} \;

# Print success message
echo ""
echo "✅ Permissions and structure fixed!"
echo "Node-RED data directory: $NR_DATA_DIR"
echo "Grafana data directory: $GRAFANA_DATA_DIR"
echo ""
echo "📌 Mount these into Docker containers as volumes:"
echo "   For Node-RED: -v $(realpath $NR_DATA_DIR):/data"
echo "   For Grafana:  -v $(realpath $GRAFANA_DATA_DIR):/var/lib/grafana"
