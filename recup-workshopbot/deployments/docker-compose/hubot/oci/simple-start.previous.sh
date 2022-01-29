#!/bin/bash

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

node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
	npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && npm i -s $POKUS_ADDITIONAL_NPM_PACKAGES && \
	bin/hubot -n $BOT_NAME -a rocketchat
























exit 0

echo "KEPT SOURCE CODE"


mkdir -p /home/hubot/pokus/secrets/.ssh
# cp /pokus/secrets/.ssh/id_rsa /home/hubot/pokus/secrets/.ssh
# cp /pokus/secrets/.ssh/id_rsa.pub /home/hubot/pokus/secrets/.ssh
# Here I will inject the SSH Key ? No, the coffescript using node-vault will do that
chmod -R 700 /home/hubot/pokus/secrets/.ssh/
chmod 644 /home/hubot/pokus/secrets/.ssh/id_rsa.pub
chmod 600 /home/hubot/pokus/secrets/.ssh/id_rsa

ssh-keyscan -vvv -t rsa -H github.com
# ssh-keyscan -t rsa -p 22 -H github.com >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H github.com >> ~/.ssh/known_hosts


mkdir -p ~/.ssh/
chmod -R 700 ~/.ssh/

if ! [ -f /home/hubot/pokus/secrets/.ssh/id_rsa ]; then
  echo "POKUS >>> [/home/hubot/pokus/secrets/.ssh/id_rsa] does NOT exists"
  # exit 67
fi;

if ! [ -f ~/.ssh/id_rsa ]; then
  echo "POKUS >>> [~/.ssh/id_rsa] does NOT exists"
  echo "POKUS >>> [ln -s /home/hubot/pokus/secrets/.ssh/id_rsa ~/.ssh/id_rsa]"
else
  echo "POKUS >>> [~/.ssh/id_rsa] DOES exists"
  echo "POKUS >>> [rm -f ~/.ssh/id_rsa && ln -s /home/hubot/pokus/secrets/.ssh/id_rsa ~/.ssh/id_rsa]"
  rm -f ~/.ssh/id_rsa || true
fi;
ln -s /pokus/secrets/.ssh/id_rsa /home/hubot/pokus/secrets/.ssh/id_rsa
ln -s /pokus/secrets/.ssh/id_rsa ~/.ssh/id_rsa

if ! [ -f ~/.ssh/id_rsa.pub ]; then
  echo "POKUS >>> [~/.ssh/id_rsa.pub] does NOT exists"
  echo "POKUS >>> [ln -s /home/hubot/pokus/secrets/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub]"
else
  echo "POKUS >>> [~/.ssh/id_rsa.pub] DOES exists"
  echo "POKUS >>> [rm -f ~/.ssh/id_rsa.pub && ln -s /home/hubot/pokus/secrets/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub]"
  rm -f ~/.ssh/id_rsa.pub || true
fi;
ln -s /pokus/secrets/.ssh/id_rsa.pub /home/hubot/pokus/secrets/.ssh/id_rsa.pub
ln -s /pokus/secrets/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub


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
