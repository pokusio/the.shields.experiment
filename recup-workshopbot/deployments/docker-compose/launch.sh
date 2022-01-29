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


launchJITSI() {

  if [ -f ./.env ]; then
    rm -f ./.env
  fi;

  cp env.example .env


  #
  chmod +x ./gen-passwords.sh
  ./gen-passwords.sh


  # Create required CONFIG directories
  mkdir -p ~/.jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
  #
  echo web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri | % { mkdir "~/.jitsi-meet-cfg/$_" }


  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"
  echo "# +x*- +x*- LES MOTS DE PASSE JITSI : "
  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"
  cat ./.env | grep PASSW
  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"


  docker-compose up -d

  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"
  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"
  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"
  echo "# +x*- +x*- JITSI IS LAUNCHED !! "
  echo "# +x*- +x*- JITSI IS LAUNCHED !! "
  echo "# +x*- +x*- JITSI IS LAUNCHED !! "
  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"
  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"
  echo "# +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- +x*- #"

}

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
export TLS_CERT_LOCALITY="Chamalires"
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
sed -i "s#POKUS_GITEA_SSH_PORT_PLACEHOLDER#${POKUS_GITEA_SSH_PORT}#g" ./.prod.env
sed -i "s#POKUS_GITEA_HTTP_PORT_PLACEHOLDER#${POKUS_GITEA_HTTP_PORT}#g" ./.prod.env
sed -i "s#POKUS_CADDY_VERSION_PLACEHOLDER#${POKUS_CADDY_VERSION}#g" ./.prod.env

sed -i "s#DRONE_HOSTNAME_PLACEHOLDER#${DRONE_HOSTNAME}#g" ./.prod.env
sed -i "s#DRONE_RPC_SECRET_PLACEHOLDER#${DRONE_RPC_SECRET}#g" ./.prod.env
# sed -i "s#GITEA_SECURITY_SECRET_KEY_PLACEHOLDER#${GITEA_SECURITY_SECRET_KEY}#g" ./.prod.env

sed -i "s#DRONE_DB_SECRETS_USER_NAME_PLACEHOLDER#${DRONE_DB_SECRETS_USER_NAME}#g" ./.prod.env
sed -i "s#DRONE_DB_SECRETS_USER_PWD_PLACEHOLDER#${DRONE_DB_SECRETS_USER_PWD}#g" ./.prod.env
sed -i "s#DRONE_VAULT_RUNNERS_SECRET_PLACEHOLDER#${DRONE_VAULT_RUNNERS_SECRET}#g" ./.prod.env
sed -i "s#VAULT_DEV_ROOT_TOKEN_ID_PLACEHOLDER#${VAULT_DEV_ROOT_TOKEN_ID}#g" ./.prod.env
# sed -i "s#VAULT_DEV_ROOT_TOKEN_ID_PATH_PLACEHOLDER#${VAULT_DEV_ROOT_TOKEN_ID_PATH}#g" ./.prod.env
sed -i "s#POKUS_GITEA_SERVER_HTTP_PROTO_PLACEHOLDER#${POKUS_GITEA_SERVER_HTTP_PROTO}#g" ./.prod.env
sed -i "s#DRONE_COOKIE_SECRET_PLACEHOLDER#${DRONE_COOKIE_SECRET}#g" ./.prod.env



# --- # --- #
# - Manquants dans le env :
# --- # --- #

# --- # --- POKUS SYSTEM
sed -i "s#POKUS_ADMIN_USER_PLACEHOLDER#${POKUS_ADMIN_USER}#g" ./.prod.env
sed -i "s#POKUS_ADMIN_PASSWORD_PLACEHOLDER#${POKUS_ADMIN_PASSWORD}#g" ./.prod.env
# --- # --- DRONE
sed -i "s#DRONE_USER_CREATE_PLACEHOLDER#${DRONE_USER_CREATE}#g" ./.prod.env
sed -i "s#DRONE_DATABASE_SECRET_PLACEHOLDER#${DRONE_DATABASE_SECRET}#g" ./.prod.env
# --- # --- N8N
sed -i "s#N8N_POSTGRES_USER_PLACEHOLDER#${N8N_POSTGRES_USER}#g" ./.prod.env
sed -i "s#N8N_POSTGRES_PASSWORD_PLACEHOLDER#${N8N_POSTGRES_PASSWORD}#g" ./.prod.env
sed -i "s#N8N_POSTGRES_DB_PLACEHOLDER#${N8N_POSTGRES_DB}#g" ./.prod.env
sed -i "s#N8N_POSTGRES_NON_ROOT_USER_PLACEHOLDER#${N8N_POSTGRES_NON_ROOT_USER}#g" ./.prod.env
sed -i "s#N8N_POSTGRES_NON_ROOT_PASSWORD_PLACEHOLDER#${N8N_POSTGRES_NON_ROOT_PASSWORD}#g" ./.prod.env

sed -i "s#DOCK_HOST_IP_ADDR_PLACEHOLDER#${DOCK_HOST_IP_ADDR}#g" ./.prod.env


echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- Content of Interpolated [./.prod.env] env file : "
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
ls -alh ./.prod.env
cat ./.prod.env
ls -alh ./.prod.env
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"



# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Now, we interpolate the [$(pwd)/gitea/app/gitea] file for gitea ssh port number
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

cat $(pwd)/gitea/app/gitea.template | tee $(pwd)/gitea/app/gitea
sed -i "s#POKUS_GITEA_SSH_PORT_PLACEHOLDER#${POKUS_GITEA_SSH_PORT}#g" $(pwd)/gitea/app/gitea


# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Generate the RSA SSH Key Pair used :
# -- # -- for the first super admin user in gitea
# -- # -- for the SSH git user of th Gitea SSH Server
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

export LE_COMMENTAIRE_DE_CLEF="git@gitea.pok-us.io"
export POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
export PRIVATE_KEY_FULLPATH=$(pwd)/gitea/donnees/.ssh/id_rsa

if [ -d $(pwd)/gitea/donnees/.ssh/ ]; then
  # rm -fr $(pwd)/gitea/donnees/.ssh/
  echo "I do not [rm -fr \$(pwd)/gitea/donnees/.ssh/], because it already exists"
fi;
if [ -f $(pwd)/gitea/donnees/.ssh/ ]; then
  rm -f $(pwd)/gitea/donnees/.ssh/
  echo "in [$(pwd)/.ssh] a file named [.ssh] exists, and should not: it should be a folder"
  exit 3
fi;
mkdir -p $(pwd)/gitea/donnees/.ssh/
ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $PRIVATE_KEY_FULLPATH -q -P "$POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Now, we interpolate the [deployments/docker-compose/gitea/donnees/.ssh/authorized_keys] file which will be used by the gitea server as authorized_keys file for git over SSH to Gitea service on ${POKUS_GITEA_SSH_PORT}/tcp port number
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
export GITEA_HOST_KEY_PLACEHOLDER=$(cat $(pwd)/gitea/donnees/.ssh/id_rsa.pub)
echo "GITEA_HOST_KEY_PLACEHOLDER=[${GITEA_HOST_KEY_PLACEHOLDER}]"

if [ -f $(pwd)/gitea/donnees/.ssh/authorized_keys ]; then
  rm -f $(pwd)/gitea/donnees/.ssh/authorized_keys
fi;
cat $(pwd)/gitea/donnees/.ssh/authorized_keys.template | tee -a $(pwd)/gitea/donnees/.ssh/authorized_keys
sed -i "s#GITEA_HOST_KEY_PLACEHOLDER#${GITEA_HOST_KEY_PLACEHOLDER}#g" gitea/donnees/.ssh/authorized_keys


# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Finally, the file permissions and owner must be set as of the POKUS_USER_UID and POKUS_USER_GID set in env. vars of the docker-compose for gitea
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

sudo chown -R $(whoami):$(whoami) $(pwd)/gitea/donnees/.ssh/
# [sudo --help] : [  -u, --user=user             run command (or edit file) as specified user name or ID]
sudo -u $(whoami) chmod -R 700 $(pwd)/gitea/donnees/.ssh/
sudo -u $(whoami) chmod -R 644 $(pwd)/gitea/donnees/.ssh/id_rsa.pub
sudo -u $(whoami) chmod -R 644 $(pwd)/gitea/donnees/.ssh/authorized_keys
sudo -u $(whoami) chmod -R 600 $(pwd)/gitea/donnees/.ssh/id_rsa

sudo chown -R $(whoami):$(whoami) $(pwd)/gitea/


# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Generate the RSA SSH Key Pair used :
# -- # -- FOR SSH KEY FOR THE POKUSBOT
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #


export LE_COMMENTAIRE_DE_CLEF="pokusbot@bot.pok-us.io"
export POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
export PRIVATE_KEY_FULLPATH=$(pwd)/hubot/secrets/.ssh/id_rsa

if [ -d $(pwd)/hubot/secrets/.ssh/ ]; then
  # rm -fr $(pwd)/gitea/donnees/.ssh/
  echo "I do not [rm -fr \$(pwd)/hubot/secrets/.ssh/], because it already exists"
fi;
if [ -f $(pwd)/hubot/secrets/.ssh/ ]; then
  rm -f $(pwd)/hubot/secrets/.ssh/
  echo "in [$(pwd)/hubot/secrets/] a file named [.ssh] exists, and should not: it should be a folder"
  exit 3
fi;
mkdir -p $(pwd)/hubot/secrets/.ssh/
ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $PRIVATE_KEY_FULLPATH -q -P "$POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"



# see related volume in the docker-compose, for the hubot


sudo chown -R $(whoami):$(whoami) $(pwd)/hubot
# [sudo --help] : [  -u, --user=user             run command (or edit file) as specified user name or ID]
sudo -u $(whoami) chmod -R 700 $(pwd)/hubot/secrets/.ssh/
sudo -u $(whoami) chmod -R 644 $(pwd)/hubot/secrets/.ssh/id_rsa.pub
sudo -u $(whoami) chmod -R 644 $(pwd)/hubot/secrets/.ssh/authorized_keys
sudo -u $(whoami) chmod -R 600 $(pwd)/hubot/secrets/.ssh/id_rsa

sudo chown -R $(whoami):$(whoami) $(pwd)/hubot/
# so that the bot can read the private ssh key file from within the container
sudo chmod -R a+r $(pwd)/hubot/
sudo chmod -R a+r $(pwd)/hubot/secrets
sudo chmod a+r $(pwd)/hubot/secrets/.ssh/id_rsa
sudo chmod a+r $(pwd)/hubot/secrets/.ssh/id_rsa.pub



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

docker volume create ${CURRFOL}_caddy_config || exit 67
docker volume create ${CURRFOL}_caddy_data || exit 67
docker volume create caddy_config || exit 67
docker volume create caddy_data || exit 67
echo "# -- volume for caddy, successfully created."
docker volume ls
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# Start a new container, automatically removes old one

resetFilePermOnSSh() {
  echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  echo "# -- resetFilePermOnSSh() [sleep 30s] "
  echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  sleep 30s
  # so that the bot can read the private ssh key file from within the container
  sudo chmod -R a+r $(pwd)/hubot/
  sudo chmod -R a+r $(pwd)/hubot/secrets
  sudo chmod a+r $(pwd)/hubot/secrets/.ssh/id_rsa
  sudo chmod a+r $(pwd)/hubot/secrets/.ssh/id_rsa.pub
  docker-compose up --force-recreate -d hubot
}

docker network create rocketchat_net

export WHERE_IAM=$(pwd)
cd ${WHERE_IAM}/jitsi
launchJITSI
cd ${WHERE_IAM}

docker-compose up -d && resetFilePermOnSSh
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
echo "    git clone git@gitea.pok-us.io:pokus/testrepo.git impossible/"

echo "    git clone git@$(hostname):${POKUS_ADMIN_USER}/testrepo.git"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
