# Install Docker
# Authors: Maxime, Renaud, Olivier and AI :-)
# Date : 2025-06-04

# Uninstall components
#for pkg in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
#sudo apt autoremove

# Define user
USER_NAME="ht"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Installer Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to Docker "group"
# Must relog to activate
# sudo usermod -aG docker user
sudo usermod -aG docker "$USER_NAME"

