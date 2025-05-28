# Installer Portainer
docker volume create portainer_data
docker run -d -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts

# Créer utilisateur admin pour Portainer
# Attention voir le volume Data existant
echo "User: admin"
echo "Mot de Pass: adminestia12025"

rm -fr /home/user/Documents/InvenTree
mkdir -p /home/user/Documents/InvenTree
cd /home/user/Documents/InvenTree

# Telecharger fichiers de conf InvenTree
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/docker-compose.yml
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/.env
wget https://raw.githubusercontent.com/inventree/inventree/e2a092ea0436f9f9805e0633b0addef5f10e6f35/contrib/container/Caddyfile

# Changer mot de passe
mkdir -p /home/user/Documents/inventree-data
sed -i \
  -e 's/^#INVENTREE_ADMIN_USER=.*/INVENTREE_ADMIN_USER=adminestia/' \
  -e 's/^#INVENTREE_ADMIN_PASSWORD=.*/INVENTREE_ADMIN_PASSWORD=adminestia2025/' \
  -e 's/^#INVENTREE_ADMIN_EMAIL=.*/INVENTREE_ADMIN_EMAIL=inventree@estia.fr/' \
  .env

# Initialize database
docker compose run --rm inventree-server invoke update

# Remplir dans le form l'info requis
echo "User: adminestia"
echo "Mail: "
echo "Mot de passe: adminestia2025"
echo "Mot de passe (conf): adminestia2025"

# Lancer le container
docker compose up -d
