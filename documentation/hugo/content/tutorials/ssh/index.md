---
title: 'Silently Generate SSH Keys'
date: 2022-01-29T10:13:37+10:50
weight: 9
---


Here is how to silently generate an SSH Key Pair :

```bash

# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Generate the RSA SSH Key Pair used :
# -- # -- for the first super admin user in shields
# -- # -- for the SSH git user of th Shields SSH Server
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

export LE_COMMENTAIRE_DE_CLEF="robots@shields.pok-us.io"
export POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
export PRIVATE_KEY_FULLPATH=$(pwd)/shields/donnees/.ssh/id_rsa

if [ -d $(pwd)/shields/donnees/.ssh/ ]; then
  # rm -fr $(pwd)/shields/donnees/.ssh/
  echo "I do not [rm -fr \$(pwd)/shields/donnees/.ssh/], because it already exists"
fi;
if [ -f $(pwd)/shields/donnees/.ssh/ ]; then
  rm -f $(pwd)/shields/donnees/.ssh/
  echo "in [$(pwd)/.ssh] a file named [.ssh] exists, and should not: it should be a folder"
  exit 3
fi;
mkdir -p $(pwd)/shields/donnees/.ssh/
ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $PRIVATE_KEY_FULLPATH -q -P "$POKUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"

# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Now, we interpolate the [deployments/docker-compose/shields/donnees/.ssh/authorized_keys] file which will be used by the shields server as authorized_keys file for git over SSH to Shields service on ${POKUS_SHIELDS_SSH_PORT}/tcp port number
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
export SHIELDS_HOST_KEY_PLACEHOLDER=$(cat $(pwd)/shields/donnees/.ssh/id_rsa.pub)
echo "SHIELDS_HOST_KEY_PLACEHOLDER=[${SHIELDS_HOST_KEY_PLACEHOLDER}]"

if [ -f $(pwd)/shields/donnees/.ssh/authorized_keys ]; then
  rm -f $(pwd)/shields/donnees/.ssh/authorized_keys
fi;
cat $(pwd)/shields/donnees/.ssh/authorized_keys.template | tee -a $(pwd)/shields/donnees/.ssh/authorized_keys
sed -i "s#SHIELDS_HOST_KEY_PLACEHOLDER#${SHIELDS_HOST_KEY_PLACEHOLDER}#g" shields/donnees/.ssh/authorized_keys


# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- Finally, the file permissions and owner must be set as of the POKUS_USER_UID and POKUS_USER_GID set in env. vars of the docker-compose for shields
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #
# ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ # ++ #

sudo chown -R $(whoami):$(whoami) $(pwd)/shields/donnees/.ssh/
# [sudo --help] : [  -u, --user=user             run command (or edit file) as specified user name or ID]
sudo -u $(whoami) chmod -R 700 $(pwd)/shields/donnees/.ssh/
sudo -u $(whoami) chmod -R 644 $(pwd)/shields/donnees/.ssh/id_rsa.pub
sudo -u $(whoami) chmod -R 644 $(pwd)/shields/donnees/.ssh/authorized_keys
sudo -u $(whoami) chmod -R 600 $(pwd)/shields/donnees/.ssh/id_rsa

sudo chown -R $(whoami):$(whoami) $(pwd)/shields/




```
