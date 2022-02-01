#!/bin/bash



# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- FUNCTIONS
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Generate TLS Cert for Root CA of Caddy Reverse Proxy Internal Issuer (no ACME server)
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- Generate TLS Cert for Root CA of Caddy Reverse Proxy Internal Issuer (no ACME server)"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

# tested on debian 11
# ----------------
# => [ /C=FR ] is for Country
# => [ /ST=Occitanie ] is for STate or province
# => [ /L=Toulouse ] is for Locality name or city
# => [ /O=Tech ] School is for Organisation
# => [ /OU=Education ] is for Organisation Unit
# => [ /CN=*.techschool.guru ] is for Common Name or domain name
# => [ /emailAddress=techschool.guru@gmail.com ] is for email address

export TLS_CERT_COUNTRY="FR"
export TLS_CERT_STATE="Auvergne"
export TLS_CERT_LOCALITY="Chamalières"
export TLS_CERT_ORGANISATION="pok-us.io"
export TLS_CERT_ORGANISATION_UNIT="devops"
# one wildcard cert for all pokus services : [caddy.pok-usio.io] [gitea.pok-usio.io] [drone.pok-usio.io] [vault.pok-usio.io] [hubot.pok-usio.io]  etc...
export TLS_CERT_COMMON_NAME="*.pok-us.io"
export TLS_CERT_EMAIL="jean.baptiste.lasselle@gmail.com"

export TLS_ID_INFOS_STR="/C=${TLS_CERT_COUNTRY}/ST=${TLS_CERT_STATE}/L=${TLS_CERT_LOCALITY}/O=${TLS_CERT_ORGANISATION}/OU=${TLS_CERT_ORGANISATION_UNIT}/CN=${TLS_CERT_COMMON_NAME}/emailAddress=${TLS_CERT_EMAIL}"
# openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem -subj "${TLS_ID_INFOS_STR}"
mkdir -p $(pwd)/pokus/tls/rootca/

echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
echo "SECURITY WARNING : the [ -nodes] openssl option is being used to silently generate TLS certificates, and that is bad, because as a consequence, some assets will not be encrypted, while they should be (or the root ca must have a secial care to insure gigh protection on non encrypted data)"
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout "$(pwd)/pokus/tls/rootca/ca-key.pem" -out "$(pwd)/pokus/tls/rootca/ca-cert.pem" -subj "${TLS_ID_INFOS_STR}"


locallyTrustCACert_GNULinux() {
  # -- right, after that the [$(pwd)/pokus/tls/rootca/ca-cert.pem] must be trusted by the Linux machien on which docker runs :
  sudo apt-get install -y ca-certificates
  export CERT_FILE_TO_TRUST=$(pwd)/pokus/tls/rootca/ca-cert.pem

  # ---
  # * Copy your CA to dir /usr/local/share/ca-certificates/
  # * Use command: sudo cp foo.crt /usr/local/share/ca-certificates/foo.crt
  # * Use command: sudo cp foo.pem /usr/local/share/ca-certificates/foo.crt
  # * Update the CA store: sudo update-ca-certificates
  # ---
  sudo cp ${CERT_FILE_TO_TRUST} /usr/local/share/ca-certificates/wildcard.pok-us.io.crt
  sudo update-ca-certificates
}

locallyTrustCACert_macos() {
  # -- right, after that the [$(pwd)/pokus/tls/rootca/ca-cert.pem] must be trusted by the Linux machien on which docker runs :
  export CERT_FILE_TO_TRUST=$(pwd)/pokus/tls/rootca/ca-cert.pem

  # ---
  # * Copy your CA to dir /usr/local/share/ca-certificates/
  # * Use command: sudo cp foo.crt /usr/local/share/ca-certificates/foo.crt
  # * Use command: sudo cp foo.pem /usr/local/share/ca-certificates/foo.crt
  # * Update the CA store: sudo update-ca-certificates
  # ---
  ls -alh  ${CERT_FILE_TO_TRUST}
}

# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- FETCH OR GENERATE SECRETS + INTERPOLATE SECRETS IN [./.prod.env.sh]
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

# ---
# How to create a 32-byte random token:
#
# $ openssl rand -hex 16
# ---
# Use openssl to generate a shared secret:
# # export GENERATED_POKUS_SECRET=$(openssl rand -hex 16)
# # # export GENERATED_POKUS_SECRET=$(openssl rand -hex 32)
# # sed -i "s#DRONE_RPC_SECRET_PLACEHOLDER#${GENERATED_POKUS_SECRET}#g" ./.prod.env.sh

# # export GENERATED_POKUS_SECRET=$(openssl rand -hex 16)
# # # export GENERATED_POKUS_SECRET=$(openssl rand -hex 32)
# # echo "GENERATED_POKUS_SECRET=[${GENERATED_POKUS_SECRET}]"
# # sed -i "s#DRONE_COOKIE_SECRET_PLACEHOLDER#${GENERATED_POKUS_SECRET}#g" ./.prod.env.sh

# # export GENERATED_POKUS_SECRET=$(openssl rand -hex 16)
# # # export GENERATED_POKUS_SECRET=$(openssl rand -hex 32)
# # echo "GENERATED_POKUS_SECRET=[${GENERATED_POKUS_SECRET}]"
# # sed -i "s#GITEA_SECURITY_SECRET_KEY_PLACEHOLDER#${GENERATED_POKUS_SECRET}#g" ./.prod.env.sh



# ---
# hashicorp vault root token
# export GENERATED_VAULT_DEV_ROOT_TOKEN_ID=$(openssl rand -hex 16)
# # export GENERATED_VAULT_DEV_ROOT_TOKEN_ID=$(openssl rand -hex 32)

# export VAULT_DEV_ROOT_TOKEN_ID_PATH=$(pwd)/vault/.secrets/vault.token
# mkdir -p $(pwd)/vault/.secrets/
# # echo "GENERATED_VAULT_DEV_ROOT_TOKEN_ID=[${GENERATED_VAULT_DEV_ROOT_TOKEN_ID}]"
# echo "${GENERATED_VAULT_DEV_ROOT_TOKEN_ID}" > ${VAULT_DEV_ROOT_TOKEN_ID_PATH}
# sed -i "s#VAULT_DEV_ROOT_TOKEN_ID_PATH_PLACEHOLDER#${VAULT_DEV_ROOT_TOKEN_ID_PATH}#g" ./.prod.env


# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- LOAD ENV FROM [./.prod.env.sh] env file
# -- INTERPOLATE [./.prod.env] env file
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #


# cat ./.prod.env | awk '{print "export " $1}'| tee -a ./.prod.env.sh
chmod +x ./.prod.env.sh
source ./.prod.env.sh
cat ./.template.env | tee ./.prod.env

sed -i "s#POKUS_USER_PLACEHOLDER#${POKUS_USER}#g" ./.prod.env
sed -i "s#POKUS_USER_UID_PLACEHOLDER#${POKUS_USER_UID}#g" ./.prod.env
sed -i "s#POKUS_USER_GID_PLACEHOLDER#${POKUS_USER_GID}#g" ./.prod.env
sed -i "s#POKUS_USER_PLACEHOLDER#${POKUS_USER}#g" ./.prod.env
sed -i "s#POKUS_USER_GRPNAME_PLACEHOLDER#${POKUS_USER_GRPNAME}#g" ./.prod.env
sed -i "s#POKUS_CADDY_VERSION_PLACEHOLDER#${POKUS_CADDY_VERSION}#g" ./.prod.env

sed -i "s#VAULT_DEV_ROOT_TOKEN_ID_PLACEHOLDER#${VAULT_DEV_ROOT_TOKEN_ID}#g" ./.prod.env


# --- # --- POKUS SYSTEM
sed -i "s#POKUS_ADMIN_USER_PLACEHOLDER#${POKUS_ADMIN_USER}#g" ./.prod.env
sed -i "s#POKUS_ADMIN_PASSWORD_PLACEHOLDER#${POKUS_ADMIN_PASSWORD}#g" ./.prod.env

sed -i "s#DOCK_HOST_IP_ADDR_PLACEHOLDER#${DOCK_HOST_IP_ADDR}#g" ./.prod.env
sed -i "s#POKUS_OCI_REGISTRY_PLACEHOLDER#${POKUS_OCI_REGISTRY}#g" ./.prod.env


echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- Content of Interpolated [./.prod.env] env file : "
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
ls -alh ./.prod.env
cat ./.prod.env
ls -alh ./.prod.env
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"








echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- POKUSBOT SSH PUB KEY TO ADD TO YOUR GITHUB USER : "
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
cat $(pwd)/hubot/secrets/.ssh/id_rsa.pub
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"


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
# -- DOCKER COMPOSE CONFIG
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- DOCKER COMPOSE CONFIG"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# Edit `docker-compose.yml` to update the version, if you have one specified
# Pull new images
docker-compose config

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- DOCKER PULL CONTAINER IMAGES
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- DOCKER PULL CONTAINER IMAGES..."
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# Edit `docker-compose.yml` to update the version, if you have one specified
# Pull new images
docker-compose pull
# docker-compose pull pokus_reverse_proxy
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- DOCKER BUILD CONTAINER IMAGES
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- DOCKER BUILD CONTAINER IMAGES..."
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

docker-compose build
# docker-compose build pokus_reverse_proxy

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- START I ALL
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- START I ALL..."
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# Before Starting, we have to create the extenal volume for caddy, or we will get an error
echo "# -- Before Starting, we have to create the extenal "
echo "# -- volume for caddy, or we will get an error"
export CURRFOL=$(echo "$(pwd)" | awk -F '/' '{print $NF}')
echo "CURRFOL=[${CURRFOL}]"

docker volume rm ${CURRFOL}_caddy_config || exit 67
docker volume rm ${CURRFOL}_caddy_data || exit 67

docker volume create ${CURRFOL}_caddy_config || exit 67
docker volume create ${CURRFOL}_caddy_data || exit 67
docker volume create caddy_config || exit 67
docker volume create caddy_data || exit 67
echo "# -- volume for caddy, successfully created."
docker volume ls
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"


docker-compose up -d

# docker-compose up -d pokus_reverse_proxy
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "    docker-compose logs -f"
echo "    docker-compose logs | more"
echo "    docker-compose down --rmi all && docker system prune -f --all && docker system prune -f --volumes"
echo "    cat ./.env"
echo "    source ./.env"
echo "    docker-compose config"
echo "    docker-compose up --force recreate -d --build"
echo "    ++ "
echo "    ++ Edit local files, and quickly respawn (without docker pull any base image or git clone anyhting again) with : "
echo "    ++ "
echo "    docker-compose down && docker system prune -f --volumes && source ./.env && docker-compose up --force-recreate --build -d"
echo "    ++ "
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- Now goto http://$(hostname):${POKUS_GITEA_HTTP_PORT} and create a repo named 'testrepo' for your user (do not create an org)"
echo "# --"
echo "# -- Then git clone this repo over SSH using : "
echo "# -- "
echo ""
echo "    ssh -Tvi $(pwd)/gitea/donnees/.ssh/id_rsa -p ${POKUS_GITEA_SSH_PORT}"
echo "    export GIT_SSH_COMMAND='ssh -i $(pwd)/gitea/donnees/.ssh/id_rsa -p ${POKUS_GITEA_SSH_PORT}'"
echo "# -- Example:"
echo "    export GIT_SSH_COMMAND='ssh -i ~/hubot-workshop/deployments/docker-compose/gitea/donnees/.ssh/id_rsa -vvv -p 2224'"
echo "    git clone robots@shields.pok-us.io:pokus/testrepo.git impossible/"

echo "    git clone git@$(hostname):${POKUS_ADMIN_USER}/testrepo.git"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
