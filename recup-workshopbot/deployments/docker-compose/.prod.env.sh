# --- POKUS NON ROOT USER
# export DOCK_HOST_IP_ADDR=192.168.1.104
# export POKUS_LX_NET_INTERFACE=<name of the linux network interface your docker daemon binds your containers to>
export POKUS_LX_NET_INTERFACE=${POKUS_LX_NET_INTERFACE:-"enp0s3"}
# export POKUS_LX_NET_INTERFACE=enp3s0
export DOCK_HOST_IP_ADDR=$(ip addr | grep -EA2 ${POKUS_LX_NET_INTERFACE} | grep 192 | awk '{print $2}' | awk -F '/' '{print $1}')
# echo "DOCK_HOST_IP_ADDR=[${DOCK_HOST_IP_ADDR}]"

# https://docs.gitea.io/en-us/install-with-docker/#configure-the-user-inside-gitea-using-environment-variables
# in the base gitea image, the non-root user is already created, with name "git"
export POKUS_USER=git
export POKUS_USER_UID=$(id -u)
# export POKUS_USER_GRPNAME=gitea
export POKUS_USER_GRPNAME=git
export POKUS_USER_GID=$(id -g)
export POKUS_GITEA_SSH_PORT=2224
export POKUS_GITEA_HTTP_PORT=7300
export POKUS_GITEA_SERVER_HTTP_PROTO=http
export POKUS_CADDY_VERSION=2.4.5
# export DRONE_RPC_SECRET=DRONE_RPC_SECRET_PLACEHOLDER
# export DRONE_RPC_SECRET=$(openssl rand -hex 16)
export DRONE_RPC_SECRET="$(echo ${HOSTNAME} | openssl dgst -md5 -hex | awk '{print $NF}')"
echo "DRONE_RPC_SECRET=[${DRONE_RPC_SECRET}]"

# export DRONE_COOKIE_SECRET=DRONE_COOKIE_SECRET_PLACEHOLDER
# export DRONE_COOKIE_SECRET=$(openssl rand -hex 16)
export DRONE_COOKIE_SECRET="$(echo ${HOSTNAME} | openssl dgst -md5 -hex | awk '{print $NF}')"
export DRONE_DATABASE_SECRET="$(echo "${HOSTNAME}-posgres-drone" | openssl dgst -md5 -hex | awk '{print $NF}')"
# export GITEA_SECURITY_SECRET_KEY=GITEA_SECURITY_SECRET_KEY_PLACEHOLDER
# export GITEA_SECURITY_SECRET_KEY=$(openssl rand -hex 16)
export GITEA_SECURITY_SECRET_KEY="$(echo ${HOSTNAME} | openssl dgst -md5 -hex | awk '{print $NF}')"
# export GENERATED_VAULT_DEV_ROOT_TOKEN_ID=$(openssl rand -hex 16)
export GENERATED_VAULT_DEV_ROOT_TOKEN_ID="$(echo ${HOSTNAME} | openssl dgst -md5 -hex | awk '{print $NF}')"
# network communication between drone server and its database will happen within the docker network, using the container name set inside [docker-compsoe.yml] for the postgres service dedicated to drone
export DRONE_DB_SECRETS_USER_NAME=drone
export DRONE_DB_SECRETS_USER_PWD=drone
export DRONE_DATABASE_NAME=dronedb
export DRONE_DATABASE_DATASOURCE="postgres://DRONE_DB_SECRETS_USER_NAME_PLACEHOLDER:DRONE_DB_SECRETS_USER_PWD_PLACEHOLDER@drone_postgres_db:5432/${DRONE_DATABASE_NAME}?sslmode=disable"
export VAULT_ADDR=${VAULT_ADDR:-"https://vault_server.pok-us.io"}
export DRONE_HOSTNAME="drone.pok-us.io"

export VAULT_TOKEN=$(cat $(pwd)/vault/.secrets/drone.token)
if [ "x${VAULT_TOKEN}" == "x" ]; then
  echo "WARNING - If the [$(pwd)/vault/.secrets/drone.token] does exist, but is empty:"
  echo "WARNING - Create the [$(pwd)/vault/.secrets/drone.token] file as a text file and only one line, the string of the Vault Token which should be used by Drone to resolve secrets."
  # exit 6
fi;


# export DRONE_VAULT_RUNNERS_SECRET_PATH=$(pwd)/vault/.secrets/drone.token
# if ! [ -f ${DRONE_VAULT_RUNNERS_SECRET_PATH} ]; then
#   echo "The [${DRONE_VAULT_RUNNERS_SECRET_PATH}] does not exist:"
#   echo "Create the [${DRONE_VAULT_RUNNERS_SECRET_PATH}] file as a text file and only one line, the string of the Vault Token which should be used by Drone to resolve secrets."
#   exit 5
# fi;
export DRONE_VAULT_RUNNERS_SECRET=$(openssl rand -hex 16)
# echo "DRONE_VAULT_RUNNERS_SECRET=[${DRONE_VAULT_RUNNERS_SECRET}]"

# if [ "x${DRONE_VAULT_RUNNERS_SECRET}" == "x" ]; then
#   echo "The [${DRONE_VAULT_RUNNERS_SECRET_PATH}] does exist, but is empty:"
#   echo "Create the [${DRONE_VAULT_RUNNERS_SECRET_PATH}] file as a text file and only one line, the string of the Vault Token which should be used by drone runners to make use of the drone vault plugin."
#   exit 8
# fi;

# export VAULT_DEV_ROOT_TOKEN_ID_PATH=VAULT_DEV_ROOT_TOKEN_ID_PATH_PLACEHOLDER
# if ! [ -f ${VAULT_DEV_ROOT_TOKEN_ID_PATH} ]; then
#   echo "The [${VAULT_DEV_ROOT_TOKEN_ID_PATH}] does not exist:"
#   echo "Create the [${VAULT_DEV_ROOT_TOKEN_ID_PATH}] file as a text file and only one line, the string of the Vault Token which should be used by Drone to resolve secrets."
#   exit 5
# fi;
# export VAULT_DEV_ROOT_TOKEN_ID=$(cat ${VAULT_DEV_ROOT_TOKEN_ID_PATH})
export VAULT_DEV_ROOT_TOKEN_ID=pokus_vault_dev_root_token_id
# if [ "x${VAULT_DEV_ROOT_TOKEN_ID}" == "x" ]; then
#   echo "The [${VAULT_DEV_ROOT_TOKEN_ID_PATH}] does exist, but is empty:"
#   echo "Create the [${VAULT_DEV_ROOT_TOKEN_ID_PATH}] file as a text file and only one line, the string of the Root Token Used to initiliaze HashCorp Vault."
#   exit 8
# fi;

export POKUS_ADMIN_USER=pokus
export POKUS_ADMIN_PASSWORD=pokus5432
export DRONE_USER_CREATE="username:${POKUS_ADMIN_USER},machine:false,admin:true,token:${DRONE_RPC_SECRET}"

export DRONE_GITEA_CLIENT_ID=changeme
export DRONE_GITEA_CLIENT_SECRET=changeme


# N8N

export N8N_POSTGRES_USER=n8n_postgres_user
export N8N_POSTGRES_PASSWORD=n8n_postgres_password
export N8N_POSTGRES_DB=n8n_postgres_db
export N8N_POSTGRES_NON_ROOT_USER=n8n_postgres_non_root_user
export N8N_POSTGRES_NON_ROOT_PASSWORD=n8n_postgres_non_root_password
