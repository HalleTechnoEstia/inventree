#!/bin/bash

# Install Tar
# Authors: Maxime, Renaud, Olivier and AI :-)
# Date: 2025-06-05

echo "Checking if 'tar' is already installed..."

if command -v tar >/dev/null 2>&1; then
    echo "'tar' is already installed. Version:"
    tar --version
else
    echo "'tar' is not installed. Installing now..."
    sudo apt update
    sudo apt install -y tar
fi