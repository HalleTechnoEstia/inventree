#!/bin/bash

cd /home/user/inventree/
mkdir backup
scp root@192.168.88.189:/home/user/inventree/backup/latest.tar /home/user/inventree/backup/
cd backup
tar -xvf latest.tar
docker cp /home/user/inventree/backup/media/ inventree-server:/home/inventree/data/
docker cp /home/user/inventree/backup/data.json inventree-server:/home/inventree/data/
docker exec -it inventree-server invoke import-records -c -f /home/inventree/data/data.json
