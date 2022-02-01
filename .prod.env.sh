# --- POKUS NON ROOT USER
# export DOCK_HOST_IP_ADDR=192.168.1.104
# export POKUS_LX_NET_INTERFACE=<name of the linux network interface your docker daemon binds your containers to>
export POKUS_LX_NET_INTERFACE=${POKUS_LX_NET_INTERFACE:-"enp0s3"}
# export POKUS_LX_NET_INTERFACE=enp3s0
export DOCK_HOST_IP_ADDR=$(ip addr | grep -EA2 ${POKUS_LX_NET_INTERFACE} | grep 192 | awk '{print $2}' | awk -F '/' '{print $1}')
# echo "DOCK_HOST_IP_ADDR=[${DOCK_HOST_IP_ADDR}]"


export POKUS_OCI_REGISTRY="${DOCK_HOST_IP_ADDR}:5000"

# https://docs.gitea.io/en-us/install-with-docker/#configure-the-user-inside-gitea-using-environment-variables
# in the base gitea image, the non-root user is already created, with name "git"
export POKUS_USER=git
export POKUS_USER_UID=$(id -u)
# export POKUS_USER_GRPNAME=gitea
export POKUS_USER_GRPNAME=git
export POKUS_USER_GID=$(id -g)

# --- CADDY
export POKUS_CADDY_VERSION=2.4.5


# --- HASICORP VAULT
export GENERATED_VAULT_DEV_ROOT_TOKEN_ID="$(echo ${HOSTNAME} | openssl dgst -md5 -hex | awk '{print $NF}')"

export VAULT_TOKEN=$(cat $(pwd)/vault/.secrets/drone.token)
if [ "x${VAULT_TOKEN}" == "x" ]; then
  echo "WARNING - If the [$(pwd)/vault/.secrets/drone.token] does exist, but is empty:"
  echo "WARNING - Create the [$(pwd)/vault/.secrets/drone.token] file as a text file and only one line, the string of the Vault Token which should be used by Drone to resolve secrets."
  # exit 6


export VAULT_DEV_ROOT_TOKEN_ID=pokus_vault_dev_root_token_id


# ---
# --- For all "First Super Admin Users"
# ---

export POKUS_ADMIN_USER=pokus
export POKUS_ADMIN_PASSWORD=pokus5432


export SHIELDS_VERSION=latest
