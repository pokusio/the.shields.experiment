#!/bin/bash


# export POKUS_GITEA_CLIENT_ID_PATH=xxxxx
# export POKUS_GITEA_CLIENT_SECRET_PATH=xxxxx

if [ "x${POKUS_GITEA_CLIENT_ID_PATH}" == "x" ]; then
  echo "Fatal Error :  The POKUS_GITEA_CLIENT_ID_PATH env. var is not set"
  exit 7
fi;


if [ "x${POKUS_GITEA_CLIENT_SECRET_PATH}" == "x" ]; then
  echo "Fatal Error :  The POKUS_GITEA_CLIENT_SECRET_PATH env. var is not set"
  exit 77
fi;

echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# ---           DRONE SERVER START UP :"
echo "# ---            Before starting up The Drone Sever, this"
echo "# ---            will wait until it finds 2 files in the filesystem"
echo "# ---           "
echo "# ---               -->> A file containing the Gitea Oauth Application Client ID : [${POKUS_GITEA_CLIENT_ID_PATH}]"
echo "# ---               -->> A file containing the Gitea Oauth Application Client Secret : [${POKUS_GITEA_CLIENT_SECRET_PATH}]"
echo "# ---           "
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"



echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Env : GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo "# --- Env : POKUS_GITEA_CLIENT_ID_PATH=[${POKUS_GITEA_CLIENT_ID_PATH}]"
echo "# --- Env : POKUS_GITEA_CLIENT_SECRET_PATH=[${POKUS_GITEA_CLIENT_SECRET_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check content of GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

ls -alh ${GITEA_SHARED_SECRETS_HOME}


echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check existence and content of POKUS_GITEA_CLIENT_ID_PATH=[${POKUS_GITEA_CLIENT_ID_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
ls -alh ${POKUS_GITEA_CLIENT_ID_PATH}
cat ${POKUS_GITEA_CLIENT_ID_PATH}
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check existence and content of POKUS_GITEA_CLIENT_SECRET_PATH=[${POKUS_GITEA_CLIENT_SECRET_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
ls -alh ${POKUS_GITEA_CLIENT_SECRET_PATH}
cat ${POKUS_GITEA_CLIENT_SECRET_PATH}
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

export DRONE_GITEA_CLIENT_ID=$(cat ${POKUS_GITEA_CLIENT_ID_PATH})
export DRONE_GITEA_CLIENT_SECRET=$(cat ${POKUS_GITEA_CLIENT_SECRET_PATH})


echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check Finally resolved secrets :"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Gitea Oauth Application Client ID : [${DRONE_GITEA_CLIENT_ID}]"
echo "# --- Gitea Oauth Application Client Secret : [${DRONE_GITEA_CLIENT_SECRET}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"


ATTEMPT=0
MAX_ATTEMPT=60
while true; do
    sleep 2s
    ATTEMPT=$(($ATTEMPT + 1))
    ls -alh ${POKUS_GITEA_CLIENT_ID_PATH}
    export POKUS_CLIENT_ID_EXIT_CODE=$?
    ls -alh ${POKUS_GITEA_CLIENT_SECRET_PATH}
    export POKUS_CLIENT_SECRET_EXIT_CODE=$?

    # if [ "$POKUS_CLIENT_ID_EXIT_CODE" == "0" ]; then
    if [ -f ${POKUS_GITEA_CLIENT_ID_PATH} ]; then
      # if [ "$POKUS_GITEA_CLIENT_SECRET_PATH" == "0" ]; then
      if [ -f ${POKUS_GITEA_CLIENT_SECRET_PATH} ]; then
        echo "Gitea Oauth Application Client ID and Client Secret are ready, Drone server can start"
        echo "# -------------------------------------------------------------------------------- #"
        echo "# ---   [LOOP TO DETECT SECRET FILES FOR GITEA OAUTH APPLICATION WERE CREATED] - "
        echo "# -------------------------------------------------------------------------------- #"
        export DRONE_GITEA_CLIENT_ID=$(cat ${POKUS_GITEA_CLIENT_ID_PATH} | jq .client_id | awk -F '"' '{print $2}')

        export DRONE_GITEA_CLIENT_SECRET=$(cat ${POKUS_GITEA_CLIENT_ID_PATH} | jq .client_secret | awk -F '"' '{print $2}')
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        echo "# ---           "
        echo "# ---           STARTING UP DRONE SERVER !!!!"
        echo "# ---           STARTING UP DRONE SERVER !!!!"
        echo "# ---           STARTING UP DRONE SERVER !!!!"
        echo "# ---           "
        echo "# ---           STARTING UP DRONE SERVER WITH:"
        echo "# ---           "
        echo "# ---               -->> Gitea Oauth Application Client ID : [${DRONE_GITEA_CLIENT_ID}]"
        echo "# ---               -->> the Gitea Oauth Application Client Secret : [${DRONE_GITEA_CLIENT_SECRET}]"
        echo "# ---           "
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
        /bin/drone-server
      elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
          exit 1
      elif ! [ "$POKUS_GITEA_CLIENT_SECRET_PATH" == "0" ]; then
          echo "# ---   Cannot start Drone server : The [${POKUS_GITEA_CLIENT_SECRET_PATH}] file does not exists yet (it should, and contian the client secret of the gitea oauth app)"
          # exit 1
      fi;

    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    elif ! [ "$POKUS_CLIENT_ID_EXIT_CODE" == "0" ]; then
        echo "# ---   Cannot start Drone server : The [${POKUS_GITEA_CLIENT_ID_PATH}] file does not exists yet (it should, and contian the client id of the gitea oauth app)"
        # exit 1
    fi;
done
# done & /bin/drone-server
