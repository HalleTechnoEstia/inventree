su - root
cd /opt/InvenTree/InvenTree-stable/contrib/container
docker compose run inventree-server invoke export-records -f data/data.json
mkdir /home/user/inventree/backup
docker cp inventree-server:/home/inventree/data/data.json /home/user/inventree/backup/
docker cp inventree-server:/home/inventree/data/media/ /home/user/inventree/backup
cd /home/user/inventree/backup
tar -cvf latest.tar data.json media/
tar -cvf $(date +%Y-%m-%d).tar data.json media/
# git config --global user.email "halle.technologique@estia.fr"
# git config --global user.name "HalleTechnoEstia"
# git add *
# git commit -m "new backup"
# git push -u origin HEAD

# docker compose run inventree-server invoke export-records -f data/backup/$(date +%Y-%m-%d).json
