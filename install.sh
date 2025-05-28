#!/bin/bash

# TO INSTALL AS ROOT

INSTALL_DIR="/home/user/Documents/InvenTree"
ADMIN_EMAIL="halle.technologique@estia.fr"
ADMIN_PSWD="estia64210"
ADMIN_USER="admin"

# Installer Portainer
docker container kill portainer
docker volume create portainer_data
docker run -d -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts

# Prépare le répertoire d'installation
rm -fr $INSTALL_DIR
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

# Telecharger fichiers de conf InvenTree
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/docker-compose.yml
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/.env
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/Caddyfile

# Changer mot de passe
mkdir -p /home/user/Documents/inventree-data
sed -i \
  -e "s/^#INVENTREE_ADMIN_USER=.*/INVENTREE_ADMIN_USER=${ADMIN_USER}/" \
  -e "s/^#INVENTREE_ADMIN_PASSWORD=.*/INVENTREE_ADMIN_PASSWORD=${ADMIN_PSWD}/" \
  -e "s/^#INVENTREE_ADMIN_EMAIL=.*/INVENTREE_ADMIN_EMAIL=${ADMIN_EMAIL}/" \
  .env

# Initialize database
docker compose run --rm inventree-server invoke update


# Lancer le container
docker compose up -d
