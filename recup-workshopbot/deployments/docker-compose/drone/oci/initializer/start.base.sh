#!/bin/bash

addSsshKeyToGiteaUser() {

  if [ "x${GITEA_POKUS_USER_ACCESS_TOKEN}" == "x" ]; then
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo " [addSsshKeyToGiteaUser()] - GITEA_POKUS_USER_ACCESS_TOKEN  is not set, but should be to be able to authenticate against the Gitea API"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo ""
    exit 2
  fi;
  if [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.pokus.user.ssh.key.id ]; then
    echo ""
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo " [addSsshKeyToGiteaUser()] - SSH KEY WAS ALREADY ADDED TO [${POKUS_ADMIN_USER}] Gitea User's SSH Keys "
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    exit 0
  else
    echo ""
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo " [addSsshKeyToGiteaUser()] - SSH KEY WAS NOT YET ADDED TO [${POKUS_ADMIN_USER}] Gitea User's SSH Keys "
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  fi;

  # On try.gitea.io i got : Powered by Gitea Version: 1.16.0+dev-345-gf2a5d1b4
  export GITEA_API_TOKEN=${GITEA_POKUS_USER_ACCESS_TOKEN}
  # echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [addSsshKeyToGiteaUser()] - GITEA_API_TOKEN=[${GITEA_API_TOKEN}] "
  echo " [addSsshKeyToGiteaUser()] - GITEA_POKUS_USER_ACCESS_TOKEN=[${GITEA_POKUS_USER_ACCESS_TOKEN}] "
  echo " [addSsshKeyToGiteaUser()] - POKUS_GITEA_SERVER_HTTP_PROTO=[${POKUS_GITEA_SERVER_HTTP_PROTO}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  # -- >>> VAULT
  # vault kv put pokus.secrets/dev/gitea/api token=${GITEA_API_TOKEN}


  # --- #
  # CREATE GITEA OAUTH APPLICATION FOR DRONE

  # ---
  # Problem of automating the creation of the Gitea OAuth App to automatically configure the drone server :https://github.com/go-gitea/gitea/issues/8764
  # Isue solved by adding an API endpoint to GItea API : https://github.com/go-gitea/gitea/pull/10437 (I can create an OAuth App from Gitea API)
  # see alo : https://discourse.gitea.io/t/any-way-to-manage-oauth2-apps-via-rest-api/1254
  # and see also : https://github.com/go-gitea/gitea/pull/14116
  # ---
  # see https://try.gitea.io/api/swagger#/user/userCreateOAuth2Application
  export POKUS_GITEA_SSH_KEY_TITLE="pokus@pokus.gitea.io"
  # Note: [/donnees/gitea/.ssh/id_rsa.pub] is mapped outside conainer so you can set your own ssh key for the initial super admin gitea user
  export POKUS_GITEA_SSH_KEY_PUB=$(cat /donnees/gitea/.ssh/id_rsa.pub)
  export POKUS_GITEA_SERVER_HTTP_PROTO=${POKUS_GITEA_SERVER_HTTP_PROTO:-"https"}
  export GITEA_API_ENDPOINT="${POKUS_GITEA_SERVER_HTTP_PROTO}://0.0.0.0:443/api/v1/user/keys"
  export JSON_PAYLOAD="{
    \"key\": \"${POKUS_GITEA_SSH_KEY_PUB}\",
    \"read_only\": true,
    \"title\": \"${POKUS_GITEA_SSH_KEY_TITLE}\"
  }"

  # this request agains Gitea API to create oauth app extremely well works
  curl -X 'POST' \
    ${GITEA_API_ENDPOINT} \
    -H "Authorization: token ${GITEA_API_TOKEN}" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d "${JSON_PAYLOAD}" | tee ./.gitea.user.ssh.keys.json | jq .

  export VERB_API_REQUEST="curl -X 'POST' ${GITEA_API_ENDPOINT} -H 'Authorization: token ${GITEA_API_TOKEN}' -H 'accept: application/json' -H 'Content-Type: application/json' -d \"${JSON_PAYLOAD}\" | tee ./.gitea.user.ssh.keys.json | jq ."


  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [addSsshKeyToGiteaUser()] - HTTP REQUEST TO GITEA API : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "#    VERB_API_REQUEST=[${VERB_API_REQUEST}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [addSsshKeyToGiteaUser()] - HTTP RESPONSE OF GITEA API TO ADD SSH KEY : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  cat ./.gitea.user.ssh.keys.json | jq .
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/
  cat ./.gitea.user.ssh.keys.json | jq . | tee ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.pokus.user.ssh.key.id
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  # export DRONE_GITEA_CLIENT_ID=$(cat ./.gitea.user.ssh.keys.json | jq .)
  # export DRONE_GITEA_CLIENT_SECRET=$(cat ./.gitea.user.ssh.keys.json | jq .)
}


# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
# echo "#  [netstat -tulpn]"
# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

# netstat -tulpn

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "     JBL TEST [find / -wholename /*caddy.json]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
find / -wholename /*caddy.json
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo ''
echo ''
echo ''

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "     JBL TEST [ls -alh caddy.json]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
ls -alh caddy.json
cat caddy.json
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo ''
echo ''
echo ''

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "     JBL TEST [curl -ivvv 0.0.0.0:443/load -X POST -H \"Content-Type: application/json\" -d @caddy.json]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
curl -ivvv 0.0.0.0:443/load -X POST -H "Content-Type: application/json" -d @caddy.json || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo ''
echo ''
echo ''

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "     JBL TEST [curl -ivvv localhost:443/load -X POST -H \"Content-Type: application/json\" -d @caddy.json]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
curl -ivvv localhost:443/load -X POST -H "Content-Type: application/json" -d @caddy.json || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo ''
echo ''
echo ''

echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [Check - /donnees/gitea/.ssh/authorized_keys]"
echo "#  [Check - /donnees/gitea/.ssh/authorized_keys]"
echo "#  [Check - /donnees/gitea/.ssh/authorized_keys]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [Content of - /donnees/]"
ls -alh /donnees/
echo "#  [Content of - /donnees/gitea/]"
ls -alh /donnees/gitea/
echo "#  [Content of - /donnees/gitea/.ssh/]"
ls -alh /donnees/gitea/.ssh/
echo "#  [Existence of - /donnees/gitea/.ssh/authorized_keys]"
ls -alh /donnees/gitea/.ssh/authorized_keys
echo "#  [Content of - /donnees/gitea/.ssh/authorized_keys]"
cat /donnees/gitea/.ssh/authorized_keys






ATTEMPT=0
MAX_ATTEMPT=20
while true; do
    sleep 1
    ATTEMPT=$(($ATTEMPT + 1))
    unset STATUS_CODE
    export STATUS_CODE=$(curl -I 0.0.0.0:443 -o /dev/null -w '%{http_code}\n' -s)
    echo "# >>>>++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "  TEST STATUS_CODE=[${STATUS_CODE}] <<<<<< "
    echo "  TEST [curl -ivvv -I 0.0.0.0:443 -w '%{http_code}\n'] <<<<<< "
    curl -ivvv -I 0.0.0.0:443 -w '%{http_code}\n'
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# >>>>++++++++++++++++++++++++++++++ #"


    # if [ $STATUS_CODE = "405" ]; then
    # if [ $STATUS_CODE = "302" ]; then
    if [ $STATUS_CODE = "200" ]; then
        echo "Caddy is ready"
        echo "# -------------------------------------------------------------------------------- #"
        echo "# ---   [LOOP TO DETECT CADDY STARTED] - configure caddy using a caddy.json"
        echo "# -------------------------------------------------------------------------------- #"

        # gitea admin create-user --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email your@email.org --must-change-password=false && addSsshKeyToGiteaUser
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "  INITIAL CADDY CONFIGURATION <<<<<< "
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
        # this command cannot be executed as long as the gitea install webui button is pressed...
        # gitea admin user create --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email pokus@pokus-io.org --access-token pokusdrone | tee ./gitea.cli.stdout
        gitea admin user create --admin --username $POKUS_ADMIN_USER --password=$POKUS_ADMIN_PASSWORD --email=pokus@pokus-io.org --access-token=true --must-change-password=false | tee ./gitea.cli.stdout
        export GITEA_POKUS_USER_ACCESS_TOKEN=$(cat ./gitea.cli.stdout | grep 'Access token was successfully created... ' | awk -F 'Access token was successfully created... ' '{print $2}')
        echo "# -------------------------------------------------------------------------------- #"
        echo "# ---   [LOOP TO DETECT CADDY STARTED] - GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]  "
        echo "# ---   [LOOP TO DETECT CADDY STARTED] - GITEA_POKUS_USER_ACCESS_TOKEN=[${GITEA_POKUS_USER_ACCESS_TOKEN}]  "
        echo "# -------------------------------------------------------------------------------- #"
        mkdir -p ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/
        echo "${GITEA_POKUS_USER_ACCESS_TOKEN}" > ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/api.token
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
        rm ./gitea.cli.stdout
        addSsshKeyToGiteaUser
        exit 0
    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    fi;
done & /usr/bin/caddy.entrypoint
