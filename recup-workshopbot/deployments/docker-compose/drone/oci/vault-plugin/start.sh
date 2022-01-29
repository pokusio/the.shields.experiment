#!/bin/bash


# export POKUS_GITEA_CLIENT_ID_PATH=xxxxx
# export POKUS_GITEA_CLIENT_SECRET_PATH=xxxxx

if [ "x${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}" == "x" ]; then
  echo "Fatal Error :  The POKUS_DRONE_VAULT_TOKEN_SECRET_PATH env. var is not set"
  exit 7
fi;


if ! [ -f ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH} ]; then
  echo "Warning :  The [${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}] file does not exists"
  # exit 77
else
  echo "Info :  The [${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}] file already exists"
fi;

echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# ---           DRONE VAULT START UP :"
echo "# ---            Before starting up The Drone Sever, this"
echo "# ---            will wait until it finds one file on the filesystem"
echo "# ---           "
echo "# ---               -->> A file containing the VAult token the drone runner will use to fetch secrets from vault : [${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}]"
echo "# ---           "
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"



echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Env : GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo "# --- Env : POKUS_DRONE_VAULT_TOKEN_SECRET_PATH=[${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check content of GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

ls -alh ${GITEA_SHARED_SECRETS_HOME}


echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check existence and content of POKUS_DRONE_VAULT_TOKEN_SECRET_PATH=[${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
cat ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}
ls -alh ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

export DRONE_SECRET=$(cat ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH})



echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check Finally resolved Vault Token :"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Drone runner vault token is : [${DRONE_SECRET}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"


ATTEMPT=0
MAX_ATTEMPT=60
while true; do
    sleep 2s
    ATTEMPT=$(($ATTEMPT + 1))
    ls -alh ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}
    export POKUS_DRONE_VAULT_TOKEN_EXIT_CODE=$?

    # if [ "$POKUS_DRONE_VAULT_TOKEN_EXIT_CODE" == "0" ]; then
    if [ -f ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH} ]; then
      echo "Drone runner vault token is ready, Drone runner can start"
      echo "# -------------------------------------------------------------------------------- #"
      echo "# ---   [LOOP TO DETECT SECRET FILE FOR DRONE VAULT VAULT TOKEN IS CREATED] - "
      echo "# -------------------------------------------------------------------------------- #"
      export DRONE_SECRET=$(cat ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH} | jq .auth.client_token | awk -F '"' '{print $2}')
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# ---           "
      echo "# ---           STARTING UP DRONE VAULT !!!!"
      echo "# ---           STARTING UP DRONE VAULT !!!!"
      echo "# ---           STARTING UP DRONE VAULT !!!!"
      echo "# ---           "
      echo "# ---           STARTING UP DRONE VAULT WITH:"
      echo "# ---           "
      echo "# ---               -->> Drone runner vault token  : DRONE_SECRET=[${DRONE_SECRET}]"
      echo "# ---           "
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      /bin/drone-vault
    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    elif ! [ "$POKUS_DRONE_VAULT_TOKEN_EXIT_CODE" == "0" ]; then
        echo "# ---   Cannot start Drone runner : The [${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}] file does not exists yet (it should, and contian the vault token used by the drone runners to fetch secrets from vault)"
        # exit 1
    fi;
done
# done & /bin/drone-server
