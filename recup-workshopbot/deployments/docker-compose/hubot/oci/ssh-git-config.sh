#!/bin/bash

# -- # -- # -- # -- # -- # -- #
# -- This scipt is used by the pokus bot to run its git configuration, SSH Key, GPG Key etc..
#
# -- # pokusPrivateSSHKeyPath = '/home/hubot/pokus/secrets/.ssh/id_rsa'
# -- # pokusPublicSSHKeyPath = '/home/hubot/pokus/secrets/.ssh/id_rsa.pub'
# -- #
# -- # pokusGpgPublicKeyPath = '/home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.pub.key'
# -- # pokusGpgPrivateKeyPath = '/home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.priv.key'
# -- # pokusGitUserNamePath = '/home/hubot/pokus/secrets/pokusbot_git_user_name'
# -- # pokusGitUserEmailPath = '/home/hubot/pokus/secrets/pokusbot_git_user_email'
# -- # pokusGitUserGpgSingingKeyPath = '/home/hubot/pokus/secrets/pokusbot_git_user_gpg_signing_key'
# --
#
export GIT_USER_NAME=$(cat /home/hubot/pokus/secrets/pokusbot_git_user_name)
export GIT_USER_EMAIL=$(cat /home/hubot/pokus/secrets/pokusbot_git_user_email)
export GIT_USER_GPG_SIGNING_KEY=$(cat /home/hubot/pokus/secrets/pokusbot_git_user_gpg_signing_key)

# -- #
# --
# # pokusGitUserNamePath = '/home/hubot/pokus/secrets/pokusbot_git_user_name'
# # pokusGitUserEmailPath = '/home/hubot/pokus/secrets/pokusbot_git_user_email'
# # pokusGitUserGpgSingingKeyPath = '/home/hubot/pokus/secrets/pokusbot_git_user_gpg_signing_key'
# --
# -- #

# --
# -- #
# --
#
# -- # -- # -- # -- # -- # -- #
# -- see also: 'deployments/docker-compose/hubot/scripts/pokus.devops.coffee'
#
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - [ssh-git-config.sh] running in : [$(pwd)]"
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - [POKUS_GIT_SSH_CMD=[${POKUS_GIT_SSH_CMD}]] "
export GIT_SSH_COMMAND=${POKUS_GIT_SSH_CMD}
echo ''
echo " [$0] - [POKUS_ADDITIONAL_NPM_PACKAGES=[${POKUS_ADDITIONAL_NPM_PACKAGES}]] "
echo " [$0] - [BOT_NAME=[${BOT_NAME}]] "
echo ''
echo " [$0] - [HUBOT_STARTUP_ROOM=[${HUBOT_STARTUP_ROOM}]] "
echo " [$0] - [HUBOT_STARTUP_MESSAGE=[${HUBOT_STARTUP_MESSAGE}]] "
echo ''
echo " [$0 - Git config] [GIT_USER_NAME=[${GIT_USER_NAME}]] "
echo " [$0 - Git config] [GIT_USER_EMAIL=[${GIT_USER_EMAIL}]] "
echo " [$0 - Git config] [GIT_USER_GPG_SIGNING_KEY=[${GIT_USER_GPG_SIGNING_KEY}]] "
echo " [$0 - Git config] [GIT_SSH_COMMAND=[${GIT_SSH_COMMAND}]] "
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# # GIT_USER_NAME
# # GIT_USER_EMAIL
# # GIT_USER_GPG_SIGNING_KEY
# # GIT_SSH_COMMAND

if [ "x${POKUS_GIT_SSH_CMD}" == "x" ]; then
 echo "Fatal Error :  The POKUS_GIT_SSH_CMD env. var is not set"
 exit 9
fi;

# # ---> # # ---> # # ---> # # ---> # # ---> # #
# # ---> # # ---> # #
# # ---> The 3 IF statements below, are each for a secret that is now fetched from [HashiCorp Vault]
# # if [ "x${GIT_USER_NAME}" == "x" ]; then
# #   echo "Fatal Error :  The GIT_USER_NAME env. var is not set"
# #   exit 10
# # fi;
# #
# # if [ "x${GIT_USER_EMAIL}" == "x" ]; then
# #   echo "Fatal Error :  The GIT_USER_EMAIL env. var is not set"
# #   exit 11
# # fi;
# #
# # if [ "x${GIT_SSH_COMMAND}" == "x" ]; then
# #   echo "Fatal Error :  The GIT_SSH_COMMAND env. var is not set"
# #   exit 12
# # fi;






if ! [ -f /home/hubot/pokus/secrets/.ssh/id_rsa.pub ]; then
 echo "Warning :  The [/home/hubot/pokus/secrets/.ssh/id_rsa.pub] file does not exists"
 exit 77
else
 echo "Info :  The [/home/hubot/pokus/secrets/.ssh/id_rsa.pub] file already exists"
fi;


if ! [ -f /home/hubot/pokus/secrets/.ssh/id_rsa ]; then
 echo "Warning :  The [/home/hubot/pokus/secrets/.ssh/id_rsa] file does not exists"
 exit 78
else
 echo "Info :  The [/home/hubot/pokus/secrets/.ssh/id_rsa] file already exists"
fi;

# # echo $GIT_SSH_PUB_KEY > /home/hubot/pokus/secrets/.ssh/id_rsa.pub
# # echo $GIT_SSH_PRIVATE_KEY > /home/hubot/pokus/secrets/.ssh/id_rsa

# # echo $POKUSIO_GPG_PUB_KEY > /home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.pub.key
# # echo $POKUSIO_GPG_PRV_KEY > /home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.priv.key
# # echo $GIT_USER_NAME > /home/hubot/pokus/secrets/git_user_name
# # echo $GIT_USER_EMAIL > /home/hubot/pokus/secrets/git_user_email


echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# ---            -+- HUBOT SSH / GPG GLOBAL GIT CONFIG -+- :"
echo "# ---            -+- HUBOT SSH / GPG GLOBAL GIT CONFIG -+- :"
echo "# ---            -+- HUBOT SSH / GPG GLOBAL GIT CONFIG -+- :"
echo "# ---            -+- HUBOT SSH / GPG GLOBAL GIT CONFIG -+- :"
echo "# ---            -+- HUBOT SSH / GPG GLOBAL GIT CONFIG -+- :"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# ---            When executing the CoffeeScript for [@pokusbot deploy <#{domainName}> <#{gitSshUri}> <#{gitVersion}> <#{hugoThemeSsh}> <#{hugoThemeVersion}>]"
echo "# ---            After SSH Keys have been retrieved from Vault Using 'node-vault' npm package, at : "
echo "# !---! # !---           Public Key : [/home/hubot/pokus/secrets/.ssh/id_rsa.pub]"
echo "# !---! # !---           Private Key : [/home/hubot/pokus/secrets/.ssh/id_rsa]"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"

# echo "# ---            Using the VAULT_TOKEN retireved from file on the filesystem at Hubot startup"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"


# !---! # !---
# We want Pub and Private SSH Keys to end up being used from [/home/hubot/pokus/secrets/.ssh]
#    Public Key : [/home/hubot/pokus/secrets/.ssh/id_rsa.pub]"
#    Private Key : [/home/hubot/pokus/secrets/.ssh/id_rsa]"
# !---! # !---


# if [ -d /home/hubot/pokus/secrets/.ssh ]; then
#   echo "Folder [/home/hubot/pokus/secrets/.ssh] already exists, deleting it.";
#   rm -fr /home/hubot/pokus/secrets/.ssh;
# fi;


echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---    FIRST: Re-format SSH Keys used for Git config"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"
echo "# !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! # !---! #"

echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "DEBUG : content of the SSH PRIVATE KEY FILE BEFORE RE-FORMATING : "
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
#    Public Key : [/home/hubot/pokus/secrets/.ssh/id_rsa.pub]"
#    Private Key : [/home/hubot/pokus/secrets/.ssh/id_rsa]"
cat /home/hubot/pokus/secrets/.ssh/id_rsa
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
# - # Re-format private and public SSH Keys used for Git config
# export SSH_PUB_KEY_CONTENT=$(cat /tmp/gravit33bot/.secrets/git_ssh_pub_key | awk -F '-----BEGIN RSA PRIVATE KEY-----' '{print $2}' | awk -F '-----END RSA PRIVATE KEY-----' '{print $1}')
# echo '-----BEGIN RSA PRIVATE KEY-----' > /tmp/gravit33bot/.secrets/git_ssh_pub_key
# echo "$SSH_PUB_KEY_CONTENT" | tr ' ' '\n' | tee -a /tmp/gravit33bot/.secrets/git_ssh_pub_key
# sed -i '$ s/$/-----END RSA PRIVATE KEY-----/' /tmp/gravit33bot/.secrets/git_ssh_pub_key
# -->> SSH Public Key is a one liner, so no need to re-format this buddy

### >>>>> !!! CHIRURGIE

# export SSH_PRIV_KEY_CONTENT=$(echo ${POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP} | awk -F '-----BEGIN RSA PRIVATE KEY-----' '{print $2}' | awk -F '-----END RSA PRIVATE KEY-----' '{print $1}')
export SSH_PRIV_KEY_CONTENT=$(cat /home/hubot/pokus/secrets/.ssh/id_rsa | awk -F '-----BEGIN RSA PRIVATE KEY-----' '{print $2}' | awk -F '-----END RSA PRIVATE KEY-----' '{print $1}')
echo '-----BEGIN RSA PRIVATE KEY-----' > ./test.poku7io.secrets.git_ssh_private_key
echo "$SSH_PRIV_KEY_CONTENT" | tr ' ' '\n' | tee -a ./test.poku7io.secrets.git_ssh_private_key
sed -i '$ s/$/-----END RSA PRIVATE KEY-----/' ./test.poku7io.secrets.git_ssh_private_key
cat ./test.poku7io.secrets.git_ssh_private_key | head -n 1 | tee ./test.poku7io.secrets.git_ssh_private_key.tmp

export NB_OF_LINES=$(cat -n  ./test.poku7io.secrets.git_ssh_private_key | awk '{print $1}' | tail -n 1)

echo ''
echo "# -+-+-  et donc toutes les lignes sauf les 2 premières : "
echo ''

echo " NB of lines minus two : [$((${NB_OF_LINES} -2))]"

# So we just get rid of the blank line number 2 :
echo '-----BEGIN RSA PRIVATE KEY-----' > ./test.poku7io.secrets.git_ssh_private_key.tmp
cat ./test.poku7io.secrets.git_ssh_private_key | tail -n $((${NB_OF_LINES} -2)) | tee -a ./test.poku7io.secrets.git_ssh_private_key.tmp

# --- and we display result for check :
cp  ./test.poku7io.secrets.git_ssh_private_key ./test.poku7io.secrets.git_ssh_private_key.backed
cat ./test.poku7io.secrets.git_ssh_private_key.tmp > ./test.poku7io.secrets.git_ssh_private_key
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "DEBUG : content of the SSH PRIVATE KEY FILE AFTER RE-FORMATING : "
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
cat ./test.poku7io.secrets.git_ssh_private_key
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
cat ./test.poku7io.secrets.git_ssh_private_key > /home/hubot/pokus/secrets/.ssh/id_rsa

### >>>>> !!! CHIRURGIE




echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "      SSH Configuration for GIT"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
export LOCAL_SSH_PUBKEY=/home/hubot/pokus/secrets/.ssh/id_rsa.pub
export LOCAL_SSH_PRVIKEY=/home/hubot/pokus/secrets/.ssh/id_rsa
# export GIT_SSH_COMMAND='ssh -i ~/pokus/secrets/.ssh/id_rsa'
if [ -d /home/hubot/pokus/secrets/.ssh ]; then
  echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
  rm -fr /home/hubot/pokus/secrets/.ssh
fi;

mkdir -p /home/hubot/pokus/secrets/.ssh/
chmod 700 /home/hubot/pokus/secrets/.ssh/
chmod 644 "${LOCAL_SSH_PUBKEY}"
chmod 600 "${LOCAL_SSH_PRVIKEY}"
ssh-add -D
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
# echo "DEBUG : content of the SSH PRIVATE KEY FILE : "
echo "SSH Configuration for GIT"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
# cat ${LOCAL_SSH_PRVIKEY}
# echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
ssh-add "${LOCAL_SSH_PRVIKEY}"
mkdir -p ~/.ssh
rm -f ~/.ssh/known_hosts
touch ~/.ssh/known_hosts
ssh-keygen -R github.com
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
ssh -Ti ~/pokus/secrets/.ssh/id_rsa git@github.com || true



echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "[$0 - Git config] [GIT_USER_NAME=[${GIT_USER_NAME}]] "
echo "[$0 - Git config] [GIT_USER_EMAIL=[${GIT_USER_EMAIL}]] "
echo "[$0 - Git config] [GIT_USER_GPG_SIGNING_KEY=[${GIT_USER_GPG_SIGNING_KEY}]] "
echo "[$0 - Git config] [GIT_SSH_COMMAND=[${GIT_SSH_COMMAND}]] "

if [ "x${GIT_USER_NAME}" == "x" ]; then
  echo "[$0 - Git config] You did not set the [GIT_USER_NAME] env. var."
  Usage
  exit 1
fi;
if [ "x${GIT_USER_EMAIL}" == "x" ]; then
  echo "[$0 - Git config] The [GIT_USER_EMAIL] env. var. was not properly set from secret manager"
  Usage
  exit 1
fi;
if [ "x${GIT_USER_GPG_SIGNING_KEY}" == "x" ]; then
  echo "[$0 - Git config] the [GIT_USER_GPG_SIGNING_KEY] env. var. was not set, So [${GIT_USER_NAME}]] won't be signed"
  git config --global commit.gpgsign false
else
  echo "[$0 - Git config] skip GPG signed git config for the moment."
  git config --global commit.gpgsign false
  # echo "[$0 - Git config] [${GIT_USER_NAME}] commits will be signed with signature [${GIT_USER_GPG_SIGNING_KEY}]"
  # git config --global commit.gpgsign true
  # git config --global user.signingkey ${GIT_USER_GPG_SIGNING_KEY}
fi;

git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"
git config --global --list
echo "[$0 - Git config] completed "

echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - SSH CONFIG SUCCESSFULLY COMPLETED!"
echo " [$0] - [ssh-git-config.sh] was running in : [$(pwd)]"
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
