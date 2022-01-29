#!/bin/bash

#
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo " [$0] - [prepare-load-ssh-keys] running in : [$(pwd)]"
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

# # echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# # echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
# # echo ''
# # echo ''
# # echo " [$0] - [POKUS_GIT_SSH_CMD=[${POKUS_GIT_SSH_CMD}]] "
# # echo " [$0] - [VAULT_TOKEN=[${VAULT_TOKEN}]] "
# # echo " [$0] - [VAULT_ADDR=[${VAULT_ADDR}]] "
# # echo ''
# # echo " [$0] - [EXTERNAL_SCRIPTS=[${EXTERNAL_SCRIPTS}]] "
# # echo " [$0] - [POKUS_ADDITIONAL_NPM_PACKAGES=[${POKUS_ADDITIONAL_NPM_PACKAGES}]] "
# # echo " [$0] - [BOT_NAME=[${BOT_NAME}]] "
# # echo ''
# # echo " [$0] - [HUBOT_STARTUP_ROOM=[${HUBOT_STARTUP_ROOM}]] "
# # echo " [$0] - [HUBOT_STARTUP_MESSAGE=[${HUBOT_STARTUP_MESSAGE}]] "
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo ''
echo ''
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"


# # echo $GIT_SSH_PUB_KEY > /home/hubot/pokus/secrets/.ssh/id_rsa.pub
# # echo $GIT_SSH_PRIVATE_KEY > /home/hubot/pokus/secrets/.ssh/id_rsa

# # echo $POKUSIO_GPG_PUB_KEY > /home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.pub.key
# # echo $POKUSIO_GPG_PRV_KEY > /home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.priv.key
# # echo $GIT_USER_NAME > /home/hubot/pokus/secrets/git_user_name
# # echo $GIT_USER_EMAIL > /home/hubot/pokus/secrets/git_user_email

if ! [ -d /home/hubot/pokus/secrets/.ssh ]; then
 echo "Warning :  The [/home/hubot/pokus/secrets/.ssh] folder does not exists, creating it."
 # exit 79
else
 echo "Info :  The [/home/hubot/pokus/secrets/.ssh] folder already exists, deleting and re-creating it."
 rm -fr /home/hubot/pokus/secrets/.ssh
 mkdir -p /home/hubot/pokus/secrets/.ssh
fi;

if ! [ -d /home/hubot/pokus/secrets/.gungpg ]; then
 echo "Warning :  The [/home/hubot/pokus/secrets/.gungpg] folder does not exists, creating it."
 mkdir -p /home/hubot/pokus/secrets/.gungpg
 # exit 80
else
 echo "Info :  The [/home/hubot/pokus/secrets/.gungpg] folder already exists, deleting and re-creating it"
 rm -fr /home/hubot/pokus/secrets/.gungpg
 mkdir -p /home/hubot/pokus/secrets/.gungpg
fi;
