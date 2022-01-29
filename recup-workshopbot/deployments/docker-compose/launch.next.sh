#!/bin/bash

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- generate the source env file and load the source env
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #

# cat ./.prod.env | awk '{print "export " $1}'| tee -a ./.prod.env.sh
chmod +x ./.prod.env.sh
source ./.prod.env.sh
cat ./.template.env | tee ./.prod.env
sed -i "s#POKUS_USER_UID_PLACEHOLDER#${POKUS_USER_UID}#g" ./.prod.env
sed -i "s#POKUS_USER_GID_PLACEHOLDER#${POKUS_USER_GID}#g" ./.prod.env


# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Generate the RSA SSH Key Pair for the gitea host
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #

export LE_COMMENTAIRE_DE_CLEF="git@gitea.pok-us.io"
export POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
export PRIVATE_KEY_FULLPATH=$(pwd)/donnees/gitea/.ssh/id_rsa

if [ -d $(pwd)/donnees/gitea/.ssh/ ]; then
  # rm -fr $(pwd)/donnees/gitea/.ssh/
  echo "I do not [rm -fr \$(pwd)/donnees/gitea/.ssh/], because it already exists"
fi;
if [ -f $(pwd)/donnees/gitea/.ssh/ ]; then
  rm -f $(pwd)/donnees/gitea/.ssh/
  echo "in [$(pwd)/.ssh] a file named [.ssh] exists, and should not: it should be a folder"
  exit 3
fi;
mkdir -p $(pwd)/donnees/gitea/.ssh/
ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $PRIVATE_KEY_FULLPATH -q -P "$POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Now, we interpolate the [deployments/docker-compose/donnees/gitea/.ssh//authorized_keys] file which will be used by the gitea server as authorized_keys file for git over SSH to Gitea service on 2224/tcp port number
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
export GITEA_HOST_KEY_PLACEHOLDER=$(cat $(pwd)/donnees/gitea/.ssh//id_rsa.pub)
echo "GITEA_HOST_KEY_PLACEHOLDER=[${GITEA_HOST_KEY_PLACEHOLDER}]"

if [ -f $(pwd)/donnees/gitea/.ssh//authorized_keys ]; then
  rm -f $(pwd)/donnees/gitea/.ssh//authorized_keys
fi;
cat $(pwd)/donnees/gitea/.ssh//authorized_keys.template | tee -a $(pwd)/donnees/gitea/.ssh//authorized_keys
sed -i "s#GITEA_HOST_KEY_PLACEHOLDER#${GITEA_HOST_KEY_PLACEHOLDER}#g" donnees/gitea/.ssh//authorized_keys

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Now, we interpolate the [$(pwd)/gitea/app/gitea] file for gitea ssh port number
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #


cat $(pwd)/gitea/app/gitea.template | tee $(pwd)/gitea/app/gitea
sed -i "s#POKUS_GITEA_SSH_PORT_PLACEHOLDER#${POKUS_GITEA_SSH_PORT}#g" $(pwd)/gitea/app/gitea


# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Finally, the file permissions and owner must be set as of the POKUS_USER_UID and POKUS_USER_GID set in env. vars of the docker-compose for gitea
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #

sudo chown -R ${POKUS_USER_UID}:${POKUS_USER_GID} $(pwd)/donnees/gitea/.ssh/
# [sudo --help] : [  -u, --user=user             run command (or edit file) as specified user name or ID]
sudo -u ${POKUS_USER_GID} chmod -R 700 $(pwd)/donnees/gitea/.ssh/
sudo -u ${POKUS_USER_GID} chmod -R 644 $(pwd)/donnees/gitea/.ssh//id_rsa.pub
sudo -u ${POKUS_USER_GID} chmod -R 644 $(pwd)/donnees/gitea/.ssh//authorized_keys
sudo -u ${POKUS_USER_GID} chmod -R 600 $(pwd)/donnees/gitea/.ssh//id_rsa

sudo chown -R ${POKUS_USER_UID}:${POKUS_USER_GID} $(pwd)/gitea/


# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- DRONE
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# Use openssl to generate a shared secret:

export GENERATED_SHARED_SECRET=$(openssl rand -hex 16)
echo "GENERATED_SHARED_SECRET=[${GENERATED_SHARED_SECRET}]"
sed -i "s#DRONE_RPC_SECRET_PLACEHOLDER#${GENERATED_SHARED_SECRET}#g" ./.prod.env.sh

# ---
# secret token for drone runner to be able to query hashicorp vault for secrets
export GENERATED_DRONE_VAULT_RUNNERS_SECRET=$(openssl rand -hex 16)

export DRONE_VAULT_RUNNERS_SECRET_PATH=$(pwd)/vault/.secrets/drone.token
mkdir -p $(pwd)/vault/.secrets/
# echo "GENERATED_DRONE_VAULT_RUNNERS_SECRET=[${GENERATED_DRONE_VAULT_RUNNERS_SECRET}]"
echo "${GENERATED_DRONE_VAULT_RUNNERS_SECRET}" > ${DRONE_VAULT_RUNNERS_SECRET_PATH}
sed -i "s#DRONE_VAULT_RUNNERS_SECRET_PLACEHOLDER#${DRONE_VAULT_RUNNERS_SECRET_PATH}#g" ./.prod.env.sh

# ---
# those two serets could be retireved from hashicorp vault
export DRONE_DB_SECRETS_USER_NAME=drone
export DRONE_DB_SECRETS_USER_PWD=drone
sed -i "s#DRONE_DB_SECRETS_USER_NAME_PLACEHOLDER#${DRONE_DB_SECRETS_USER_NAME}#g" ./.prod.env.sh
sed -i "s#DRONE_DB_SECRETS_USER_PWD_PLACEHOLDER#${DRONE_DB_SECRETS_USER_PWD}#g" ./.prod.env.sh

source ./.prod.env.sh
sed -i "s#DRONE_HOSTNAME_PLACEHOLDER#${DRONE_HOSTNAME}#g" ./.prod.env
sed -i "s#DRONE_RPC_SECRET_PLACEHOLDER#${DRONE_RPC_SECRET}#g" ./.prod.env

sed -i "s#DRONE_DB_SECRETS_USER_NAME_PLACEHOLDER#${DRONE_DB_SECRETS_USER_NAME}#g" ./.prod.env
sed -i "s#DRONE_DB_SECRETS_USER_PWD_PLACEHOLDER#${DRONE_DB_SECRETS_USER_PWD}#g" ./.prod.env

sed -i "s#DRONE_VAULT_RUNNERS_SECRET_PLACEHOLDER#${DRONE_VAULT_RUNNERS_SECRET}#g" ./.prod.env

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Switch to prod env.
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
if [ -f ./.env ]; then
  echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  echo "# -- A file named [./.env] already exists, will be "
  echo "# -- deleted, and its content was:"
  echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  cat ./.env
  echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  rm -f ./.env
fi;
cp ./.prod.env ./.env
source ./.env
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- DOCKER PULL CONTAINER IMAGES
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- DOCKER PULL CONTAINER IMAGES..."
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# Edit `docker-compose.yml` to update the version, if you have one specified
# Pull new images
docker-compose pull
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- DOCKER BUILD CONTAINER IMAGES
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- DOCKER BUILD CONTAINER IMAGES..."
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

docker-compose build

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- START I ALL
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- START I ALL..."
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# Start a new container, automatically removes old one
docker-compose up -d
