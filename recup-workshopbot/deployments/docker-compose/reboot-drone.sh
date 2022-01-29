#!/usr/bin/env bash

# export DOCK_HOST_IP_ADDR=192.168.1.101
# export GITEA_ADMIN_USER="pokus"
# export DRONE_RPC_SECRET="$(echo ${HOSTNAME} | openssl dgst -md5 -hex)"
# export DRONE_USER_CREATE="username:${GITEA_ADMIN_USER},machine:false,admin:true,token:${DRONE_RPC_SECRET}"

docker-compose up --force-recreate -d drone_server drone_runner

echo ""
echo "Gitea: http://${IP_ADDRESS}:3000/"
echo "Drone: http://${IP_ADDRESS}:3001/"
