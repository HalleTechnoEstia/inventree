#!/bin/bash

# Backup DataBase and Media
# Authors: Maxime, Renaud, Olivier and AI :-)
# Date : 2025-06-05

# Define user name
USER_NAME="ht"

# Go to Backup Directory
cd /home/$USER_NAME/inventree/backup

# UnTar latest archive
tar -xvf latest.tar

# Copy data to inventree-server Container
docker cp /home/$USER_NAME/inventree/backup/media/ inventree-server:/home/inventree/data/
docker cp /home/$USER_NAME/inventree/backup/data.json inventree-server:/home/inventree/data/

# Import latest data base to Inventree
docker exec -it inventree-server invoke import-records -c -f /home/inventree/data/data.json
