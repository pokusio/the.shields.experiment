#!/bin/bash

set +x

VAULT_RETRIES=5
echo "Vault is starting..."
until vault status > /dev/null 2>&1 || [ "$VAULT_RETRIES" -eq 0 ]; do
        echo "# --- Waiting for vault to start...: $((VAULT_RETRIES--))"
        sleep 1
done

echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- VAULT_DEV_ROOT_TOKEN_ID=[${VAULT_DEV_ROOT_TOKEN_ID}]"
echo "# --- GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"



echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Authenticating to vault..."
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
# vault login token=vault-plaintext-root-token
vault login token=${VAULT_DEV_ROOT_TOKEN_ID}
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Initializing vault..."
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
vault secrets enable -version=2 -path=pokus.secrets/ kv
vault secrets enable -version=2 -path=pokus.hubot.secrets/ kv
vault secrets enable -path=secret/ kv

echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Adding entries for gitea, drone, and rocketchat databases..."
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- # + pokus.secrets/dev/gitea/postgres test_username"
echo "# --- # + pokus.secrets/dev/gitea/postgres test_password"
echo "# --- # + pokus.secrets/dev/drone/postgres test_username"
echo "# --- # + pokus.secrets/dev/drone/postgres test_password"
echo "# --- # + pokus.secrets/dev/rocketchat/mongo test_username"
echo "# --- # + pokus.secrets/dev/rocketchat/mongo test_password"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- "
vault kv put pokus.secrets/dev_gitea postgres_username=test_user postgres_password=test_password

vault kv put pokus.secrets/dev_drone postgres_username=test_user postgres_password=test_password

vault kv put pokus.secrets/dev_rocketchat mongo_username=test_user mongo_password=test_password


vault kv get -format=json pokus.secrets/dev_gitea
vault kv get -format=json pokus.secrets/dev_drone
vault kv get -format=json pokus.secrets/dev_rocketchat

echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- TEST READING SECRETS WITH VAULT CLIENT"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
vault kv get -format=json pokus.secrets/dev_gitea
vault read -field=value pokus.secrets/dev_gitea/postgres_password | tee ~/whatever


# vault read -field=value secret/ssh-keys/centos.pem > ~/.ssh/id_rsa-centos.pem
# chmod 600 ~/.ssh/id_rsa-centos.pem


echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- view the default token..."
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

# view the default token
vault read sys/policy/default


echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Create Drone Runner's Vault ACL Policy"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
# path "secret/dev/team-1/*" {
#   capabilities = ["create", "update", "read"]
# }

cat << EOF > ./drone_policy.hcl
path "pokus.secrets/*" {
  capabilities = ["read"]
}
EOF

vault policy write drone_policy drone_policy.hcl


echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Creating Drone Runner vault token..."
echo "# --- Assign Vault ACL Policy to Vault Token for Drone Runner"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

# disables always attaching the default token
# vault token create -no-default-policy
# vault token create -policy=drone_policy
# see https://learn.hashicorp.com/tutorials/vault/getting-started-authentication?in=vault/getting-started

vault token create -no-default-policy -format=json -policy=drone_policy | tee dronerunners.vault.token.json


# export POKUS_DRONE_VAULT_TOKEN_SECRET_PATH=/pokus/.shared.secrets/dev/drone-runner/vault.token
export ZE_FILENAME=$(echo ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH} | awk -F '/' '{print $NF}')
export PATH_WITHOUT=$(echo ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH} | awk -F "${ZE_FILENAME}" '{print $1}' )

echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Creating ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}"
echo "# ---   ZE_FILENAME=[${ZE_FILENAME}]"
echo "# ---   PATH_WITHOUT=[${PATH_WITHOUT}]"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

mkdir -p ${PATH_WITHOUT}
cat dronerunners.vault.token.json | tee ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}


echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Created ${PATH_WITHOUT} : "
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo ''
echo ''
ls -alh ${PATH_WITHOUT}
echo ''
echo ''
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- FINISHED creating ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo ''
echo ''
echo ''


# --- Hubot's SSH Key pair to be able to git over ssh to github / gitea
# https://codingbee.net/vault/downloading-private-ssh-keys-from-hashicorp-vault

echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Create Hubot's Vault ACL Policy"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
# path "secret/dev/team-1/*" {
#   capabilities = ["create", "update", "read"]
# }

cat << EOF > ./hubot_policy.hcl
path "pokus.hubot.secrets/*" {
  capabilities = ["read"]
}
EOF

vault policy write hubot_policy hubot_policy.hcl


echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Creating Hubot's vault token..."
echo "# --- Assign Vault ACL Policy to Vault Token for Hubot"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

# --- #
# disables always attaching the default token
# vault token create -no-default-policy
# vault token create -policy=drone_policy
# see https://learn.hashicorp.com/tutorials/vault/getting-started-authentication?in=vault/getting-started

vault token create -no-default-policy -format=json -policy=hubot_policy | tee hubot.vault.token.json


# export POKUS_DRONE_VAULT_TOKEN_SECRET_PATH=/pokus/.shared.secrets/dev/drone-runner/vault.token
export ZE_FILENAME=$(echo ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} | awk -F '/' '{print $NF}')
export PATH_WITHOUT=$(echo ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} | awk -F "${ZE_FILENAME}" '{print $1}' )

echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Creating ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}"
echo "# ---   ZE_FILENAME=[${ZE_FILENAME}]"
echo "# ---   PATH_WITHOUT=[${PATH_WITHOUT}]"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

mkdir -p ${PATH_WITHOUT}
cat hubot.vault.token.json | tee ${POKUS_DRONE_VAULT_TOKEN_SECRET_PATH}


echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Created ${PATH_WITHOUT} (hubot.vault.token.json) : "
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo ''
echo ''
ls -alh ${PATH_WITHOUT}
echo ''
echo ''
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- FINISHED creating ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo ''
echo ''
echo ''



if ! [ -f ${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH} ]; then
  echo "Warning :  The [${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}] file does not exists"
  # exit 77
else
  echo "Info :  The [${POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH}] file already exists"
fi;


echo ''
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- STORE POKUSBOT SECRETS IN VAULT :"
echo "   pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key"
echo "   pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key"
echo "   pokus.hubot.secrets/dev_hubot/pokusbot.gpg.pub.key"
echo "   pokus.hubot.secrets/dev_hubot/pokusbot.gpg.priv.key"
echo "   pokus.hubot.secrets/dev_hubot/git_user_name"
echo "   pokus.hubot.secrets/dev_hubot/git_user_email"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo ''
echo ''

# # !--- SSH PUBLIC KEY FILE :
# #    Public Key : [/home/hubot/pokus/secrets/.ssh/id_rsa.pub]"
# # // $ vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key > /home/hubot/pokus/secrets/.ssh/id_rsa.pub
# # // $ chmod 600 /home/hubot/pokus/secrets/.ssh/id_rsa.pub
# pokusPublicSSHKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key')).catch(console.error);
# # !--- SSH PRIVATE KEY FILE :
# #    Private Key : [/home/hubot/pokus/secrets/.ssh/id_rsa]"
# # // $ vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key > /home/hubot/pokus/secrets/.ssh/id_rsa
# # // $ chmod 644 /home/hubot/pokus/secrets/.ssh/id_rsa

# pokusPrivateSSHKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key')).catch(console.error);
# pokusGpgPublicKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot.gpg.pub.key') # pokusbot.gpg.pub.key
# pokusGpgPrivateKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot.gpg.priv.key') # pokusbot.gpg.priv.key
# pokusGitUserName = vault.read('pokus.hubot.secrets/dev_hubot/git_user_name') # git_user_name
# pokusGitUserEmail = vault.read('pokus.hubot.secrets/dev_hubot/git_user_email') # git_user_email


echo "# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #"
echo "# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- Generate the RSA SSH Key Pair used :"
echo "# -- # -- FOR SSH KEY FOR THE POKUSBOT"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
echo "# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #"
echo "# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #"


export LE_COMMENTAIRE_DE_CLEF="pokusbot@bot.pok-us.io"
export POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
export PRIVATE_KEY_FULLPATH=$(pwd)/pokus.secrets.ssh.id_rsa

echo ''
echo ''
echo ''

ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $PRIVATE_KEY_FULLPATH -q -P "$POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"
echo ''
echo ''
echo ''


export POKUS_HUBOT_PUBLIC_SSH_KEY_VALUE=$(cat $(pwd)/pokus.secrets.ssh.id_rsa.pub)
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "DEBUG : SSH PUBLIC KEY IS  A LONE LINER NO NEED TO FORMAT "
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "   [POKUS_HUBOT_PUBLIC_SSH_KEY_VALUE=[${POKUS_HUBOT_PUBLIC_SSH_KEY_VALUE}]]"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"

export POKUS_HUBOT_PUBLIC_SSH_KEY_LINEDUP=${POKUS_HUBOT_PUBLIC_SSH_KEY_VALUE}

# export POKUS_HUBOT_PUBLIC_SSH_KEY_LINEDUP=$(echo ${POKUS_HUBOT_PUBLIC_SSH_KEY_VALUE} | tr '\n' ' ')

echo ''
echo ''
echo ''

export POKUS_HUBOT_PRIVATE_SSH_KEY_VALUE=$(cat $(pwd)/pokus.secrets.ssh.id_rsa)
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "DEBUG : value of the SSH PRIVATE KEY !BEFORE! formating in one line : "
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "   [POKUS_HUBOT_PRIVATE_SSH_KEY_VALUE=[${POKUS_HUBOT_PRIVATE_SSH_KEY_VALUE}]]"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"

export POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP=${POKUS_HUBOT_PRIVATE_SSH_KEY_VALUE}

export POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP=$(echo ${POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP} | tr '\n' ' ' )
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "DEBUG : value of the SSH PRIVATE POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP !AFTER! formating in one line : "
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "   [POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP=[${POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP}]]"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo ''
echo ''
echo ''
# --- EXACT RECIPOQUE OPERATION THAN (see [deployments/docker-compose/hubot/oci/ssh-git-config.sh]) :
# export SSH_PRIV_KEY_CONTENT=$(echo ${POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP} | awk -F '-----BEGIN RSA PRIVATE KEY-----' '{print $2}' | awk -F '-----END RSA PRIVATE KEY-----' '{print $1}')
# echo '-----BEGIN RSA PRIVATE KEY-----' > ./test.poku7io.secrets.git_ssh_private_key
# echo "$SSH_PRIV_KEY_CONTENT" | tr ' ' '\n' | tee -a ./test.poku7io.secrets.git_ssh_private_key
# sed -i '$ s/$/-----END RSA PRIVATE KEY-----/' ./test.poku7io.secrets.git_ssh_private_key
# cat ./test.poku7io.secrets.git_ssh_private_key | head -n 1 | tee ./test.poku7io.secrets.git_ssh_private_key.tmp
#
# export NB_OF_LINES=$(cat -n  ./test.poku7io.secrets.git_ssh_private_key | awk '{print $1}' | tail -n 1)
#
# echo ''
# echo "# -+-+-  et donc toutes les lignes sauf les 2 premières : "
# echo ''
#
# echo " NB of lines minus two : [$((${NB_OF_LINES} -2))]"
#
# # So we just get rid of the blank line number 2 :
# echo '-----BEGIN RSA PRIVATE KEY-----' > ./test.poku7io.secrets.git_ssh_private_key.tmp
# cat ./test.poku7io.secrets.git_ssh_private_key | tail -n $((${NB_OF_LINES} -2)) | tee -a ./test.poku7io.secrets.git_ssh_private_key.tmp
#
# # --- and we display result for check :
# cp  ./test.poku7io.secrets.git_ssh_private_key ./test.poku7io.secrets.git_ssh_private_key.backed
# cat ./test.poku7io.secrets.git_ssh_private_key.tmp > ./test.poku7io.secrets.git_ssh_private_key
# echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
# echo "DEBUG : content of the SSH PRIVATE KEY FILE AFTER RE-FORMATING : "
# echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
# cat ./test.poku7io.secrets.git_ssh_private_key
# echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"

echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -->> STORE [HUBOT SSH Private Key] INTO VAULT"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
vault kv put pokus.hubot.secrets/dev_hubot pokusbot_ssh_priv_key="${POKUS_HUBOT_PRIVATE_SSH_KEY_LINEDUP}"
echo ''
echo ''
echo ''

echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -->> Test Reading back HUBOT SSH Private Key : "
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key > ./tmp.pokusbot_ssh_priv_key
cat ./tmp.pokusbot_ssh_priv_key
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo ''
echo ''
echo ''


echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -->> STORE [HUBOT SSH Public Key] INTO VAULT"
echo "# -->> SSH Public Key is a one liner, so no need to re-format this buddy"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
export POKUS_HUBOT_PUBLIC_SSH_KEY_VALUE=$POKUS_HUBOT_PUBLIC_SSH_KEY_LINEDUP
# MERCKKK
vault kv put pokus.hubot.secrets/dev_hubot pokusbot_ssh_pub_key="${POKUS_HUBOT_PUBLIC_SSH_KEY_VALUE}"
echo ''
echo ''
echo ''

echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -->> Test Reading back HUBOT SSH Public Key : "
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key > ./tmp.pokusbot_ssh_pub_key
cat ./tmp.pokusbot_ssh_pub_key

echo ''
echo ''
echo ''


echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- #  >>>>>>>>>>>>>>  >>>>>>>>>>>>>>  >>>>>>>>>>>>>>  >>>>>>"
echo "# --- Before STORING HUBOT GIT USER NAME, EMAIL, AND GPG SIGNING KEY"
echo "# --- #  >>>>>>>>>>>>>>  >>>>>>>>>>>>>>  >>>>>>>>>>>>>>  >>>>>>"
echo "# ---   HUBOT_GIT_USER_NAME=[${HUBOT_GIT_USER_NAME}]"
echo "# ---   HUBOT_GIT_USER_EMAIL=[${HUBOT_GIT_USER_EMAIL}]"
echo "# ---   HUBOT_GIT_USER_GPG_SIGNING_KEY=[${HUBOT_GIT_USER_GPG_SIGNING_KEY}]"
echo "# --- #  >>>>>>>>>>>>>>  >>>>>>>>>>>>>>  >>>>>>>>>>>>>>  >>>>>>"
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

echo ''
echo ''
echo ''

echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -->> STORE [HUBOT_GIT_USER_NAME] INTO VAULT"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
vault kv put pokus.hubot.secrets/dev_hubot pokusbot_git_user_name="${HUBOT_GIT_USER_NAME}"
echo ''
echo ''
echo ''

echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -->> STORE [HUBOT_GIT_USER_EMAIL] INTO VAULT"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
vault kv put pokus.hubot.secrets/dev_hubot pokusbot_git_user_email="${HUBOT_GIT_USER_EMAIL}"

echo ''
echo ''
echo ''
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -->> STORE [HUBOT_GIT_USER_GPG_SIGNING_KEY] INTO VAULT"
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
vault kv put pokus.hubot.secrets/dev_hubot pokusbot_git_user_gpg_signing_key="${HUBOT_GIT_USER_GPG_SIGNING_KEY}"


# --- #
echo ''
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- FINAL TEST READING FROM VAULT :"
echo "   pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key"
echo "   pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key"
echo "   vault kv get -format=json pokus.hubot.secrets/dev_hubot   "
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo ''
echo ''
vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key | tee ~/whatever
vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key | tee ~/whatever
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
echo "# -+-+   vault kv get -format=json pokus.hubot.secrets/dev_hubot   "
#
# --- #
#
vault kv get -format=json pokus.hubot.secrets/dev_hubot
echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"

#
# --- #
#

# echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
# echo "# --- vault path-help auth"
# echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

# vault path-help auth/token
echo ''
echo ''
echo ''
echo ''
echo ''
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"
echo "# --- Completed vault Initialization!!!!..."
echo "# --- sleep 300s ..."
echo "# --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #  --- #"

# --- #
# sleep 300s so you can docker exec into the container, to have a look at the secrets...
sleep 300s
