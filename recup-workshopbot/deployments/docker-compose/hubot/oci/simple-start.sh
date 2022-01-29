#!/bin/bash

set +x

#
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - [simplestart.sh] running in : [$(pwd)]"
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - [POKUS_GIT_SSH_CMD=[${POKUS_GIT_SSH_CMD}]] "
echo " [$0] - [EXTERNAL_SCRIPTS=[${EXTERNAL_SCRIPTS}]] "
echo " [$0] - [POKUS_ADDITIONAL_NPM_PACKAGES=[${POKUS_ADDITIONAL_NPM_PACKAGES}]] "
echo " [$0] - [BOT_NAME=[${BOT_NAME}]] "
echo " [$0] - [VAULT_TOKEN=[${VAULT_TOKEN}]] "
echo " [$0] - [VAULT_ADDR=[${VAULT_ADDR}]] "
echo " [$0] - [HUBOT_STARTUP_ROOM=[${HUBOT_STARTUP_ROOM}]] "
echo " [$0] - [HUBOT_STARTUP_MESSAGE=[${HUBOT_STARTUP_MESSAGE}]] "
echo " [$0] -  : GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo " [$0] -  : POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH=[${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}]"
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"






if [ "x${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}" == "x" ]; then
  echo "Fatal Error :  The POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH env. var is not set"
  exit 7
fi;


if ! [ -f ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} ]; then
  echo "Warning :  The [${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}] file does not exists"
  # exit 77
else
  echo "Info :  The [${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}] file already exists"
fi;

echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Env : GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo "# --- Env : POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH=[${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check content of GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

ls -alh ${GITEA_SHARED_SECRETS_HOME}


echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check existence and content of POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH=[${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
cat ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}
ls -alh ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

export VAULT_TOKEN=$(cat ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} | jq .auth.client_token | awk -F '"' '{print $2}')



echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check Finally resolved Vault Token :"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Hubot vault token is : [${VAULT_TOKEN}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"



echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# ---           Hubot START UP :"
echo "# ---            Before starting up The Hubot, this"
echo "# ---            will wait until it finds one file on the filesystem"
echo "# ---           "
echo "# ---               -->> A file containing the Vault token the hubot will use to retrieve its git ssh key from hashicorp vault : [${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}]"
echo "# ---           "
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"





echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check existence and content of POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH=[${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
cat ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}
ls -alh ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

export VAULT_TOKEN=$(cat ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} | jq .auth.client_token | awk -F '"' '{print $2}')



echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Check Finally resolved Vault Token :"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Hubot Vault Token is : [${VAULT_TOKEN}]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"



### >#>#>#>#># CHIRURGIE3

ATTEMPT=0
MAX_ATTEMPT=60
while true; do
    sleep 2s
    ATTEMPT=$(($ATTEMPT + 1))
    ls -alh ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}
    export POKUS_HUBOT_VAULT_TOKEN_EXIT_CODE=$?

    echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
    echo "# --- Check existence and content of POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH=[${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}]"
    echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
    cat ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}
    ls -alh ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}
    echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"



    # if [ "$POKUS_HUBOT_VAULT_TOKEN_EXIT_CODE" == "0" ]; then
    if [ -f ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} ]; then
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "HUBOT / POKUSBOT vault token is ready, HUBOT / POKUSBOT can start"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# -------------------------------------------------------------------------------- #"
      echo "# ---   [LOOP TO DETECT SECRET FILE FOR HUBOT / POKUSBOT VAULT TOKEN IS CREATED] - "
      echo "# -------------------------------------------------------------------------------- #"
      export VAULT_TOKEN=$(cat ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} | jq .auth.client_token | awk -F '"' '{print $2}')
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# ---           "
      echo "# ---           STARTING UP HUBOT / POKUSBOT !!!!"
      echo "# ---           STARTING UP HUBOT / POKUSBOT !!!!"
      echo "# ---           STARTING UP HUBOT / POKUSBOT !!!!"
      echo "# ---           "
      echo "# ---           STARTING UP HUBOT / POKUSBOT WITH:"
      echo "# ---           "
      echo "# ---               -->> HUBOT / POKUSBOT vault token  : VAULT_TOKEN=[${VAULT_TOKEN}]"
      echo "# ---           "
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
      echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"

      node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
      	npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && npm i -s $POKUS_ADDITIONAL_NPM_PACKAGES && \
      	bin/hubot -n $BOT_NAME -a rocketchat

    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    elif ! [ "$POKUS_HUBOT_VAULT_TOKEN_EXIT_CODE" == "0" ]; then
        echo "# ---   Cannot start HUBOT / POKUSBOT : The [${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}] file does not exists yet (it should, and contian the vault token used by the HUBOT/POKUBOT to fetch secrets from vault)"
        # exit 1
    fi;
done

### >#>#>#>#># CHIRURGIE3



























exit 0


echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - [simplestart.sh] content of [/home/hubot/pokus/secrets/.ssh/] :"
ls -alh /home/hubot/pokus/secrets/.ssh/
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - [simplestart.sh] test ssh against github.com :"
ssh -Tvai /home/hubot/pokus/secrets/.ssh/id_rsa git@github.com || true
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
