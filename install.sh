#!/bin/bash

# Install
#	1 Portainer
#	2 Inventree
# Authors: Maxime, Renaud, Olivier and AI :-)
# Date : 2025-06-04

# TO INSTALL AS ROOT

# Exit on error
set -e

# Define user name
USER_NAME="ht"

# Define GitHub Directory
GIT_DIR="inventree"
# Define Application Directory
APPLICATION_DIR="Applications"
# Define Install Directory
INSTALL_DIR="/home/$USER_NAME/$APPLICATION_DIR/InvenTree"
# Define Inventree Data path
INVENTREE_DATA_DIR="/home/$USER_NAME/$APPLICATION_DIR/inventree-data"
# Define Inventree URL
INVENTREE_URL="http:\/\/inventree.estia.fr"
# Define Inventree first install Admin parameters
ADMIN_EMAIL="halle.technologique@estia.fr"
ADMIN_PSWD="estia64210"
ADMIN_USER="admin"

# Check and create directories
# Directory path to check/create
DIR_PATH="/home/$USER_NAME/$GIT_DIR"
# Check if directory exists
if [ -d "$DIR_PATH" ]; then
  echo "✅ Directory already exists: $DIR_PATH"
else
  echo "📁 Directory does not exist. Creating: $DIR_PATH"
  mkdir -p "$DIR_PATH"

  # Optional: check if creation succeeded
  if [ -d "$DIR_PATH" ]; then
    echo "✅ Directory successfully created."
  else
    echo "❌ Failed to create directory." >&2
    exit 1
  fi
fi
# Directory path to check/create
DIR_PATH="/home/$USER_NAME/$APPLICATION_DIR"
# Check if directory exists
if [ -d "$DIR_PATH" ]; then
  echo "✅ Directory already exists: $DIR_PATH"
else
  echo "📁 Directory does not exist. Creating: $DIR_PATH"
  mkdir -p "$DIR_PATH"

  # Optional: check if creation succeeded
  if [ -d "$DIR_PATH" ]; then
    echo "✅ Directory successfully created."
  else
    echo "❌ Failed to create directory." >&2
    exit 1
  fi
fi

# Install Portainer (stops existing instance if running)
docker container kill portainer || true
docker volume create portainer_data
docker run -d \
  -p 9000:9000 -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:lts

# Prepare installation directory
# Remove directory if existing
rm -rf "$INSTALL_DIR"
# Make directory
mkdir -p "$INSTALL_DIR"
# Go in directory
cd "$INSTALL_DIR"

# Download InvenTree config files
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/docker-compose.yml
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/.env
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/Caddyfile

# Create Inventree data directory
mkdir -p "$INVENTREE_DATA_DIR"

# Set admin credentials in .env
sed -i \
  -e "s/^#INVENTREE_ADMIN_USER=.*/INVENTREE_ADMIN_USER=${ADMIN_USER}/" \
  -e "s/^#INVENTREE_ADMIN_PASSWORD=.*/INVENTREE_ADMIN_PASSWORD=${ADMIN_PSWD}/" \
  -e "s/^#INVENTREE_ADMIN_EMAIL=.*/INVENTREE_ADMIN_EMAIL=${ADMIN_EMAIL}/" \
  -e "s/^#INVENTREE_SITE_URL=.*/INVENTREE_SITE_URL=${INVENTREE_URL}/" \
  .env

# Initialize the database
docker compose run --rm inventree-server invoke update

# Launch containers
docker compose up -d

# Final message
echo "✅ Installation complete. Visit $INVENTREE_URL to access InvenTree."