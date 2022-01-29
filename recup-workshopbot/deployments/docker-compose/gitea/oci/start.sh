#!/bin/bash

addSsshKeyToGiteaUser() {

  if [ "x${GITEA_POKUS_USER_ACCESS_TOKEN}" == "x" ]; then
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo " [addSsshKeyToGiteaUser()] - GITEA_POKUS_USER_ACCESS_TOKEN  is not set, but should be to be able to authenticate against the Gitea API"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo ""
    exit 2
  fi;
  if [ -f ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.pokus.user.ssh.key.id ]; then
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
  export GITEA_API_ENDPOINT="${POKUS_GITEA_SERVER_HTTP_PROTO}://0.0.0.0:3000/api/v1/user/keys"
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
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/dev/drone/
  cat ./.gitea.user.ssh.keys.json | jq . | tee ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.pokus.user.ssh.key.id
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  # export DRONE_GITEA_CLIENT_ID=$(cat ./.gitea.user.ssh.keys.json | jq .)
  # export DRONE_GITEA_CLIENT_SECRET=$(cat ./.gitea.user.ssh.keys.json | jq .)
}

createDroneOauthApp() {
  if [ -f ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_id ]; then
    if [ -f ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_secret ]; then
      echo ""
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      echo " [createDroneOauthApp()] - BOTH CLIENT ID AND CLIENT SECRET WERE CREATED "
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      exit 0
    else
      echo ""
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      echo " [createDroneOauthApp()] - CLIENT ID HAS BEEN CREATED, BUT IT SEEMS THAT CLIENT SECRET HAS NOT, THIS IS AN ANOMALY...  STOPPING..  "
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      exit 3
    fi;
  else
    if [ -f ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_secret ]; then
      echo ""
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      echo " [createDroneOauthApp()] - CLIENT SECRET HAS BEEN CREATED, BUT IT SEEMS THAT CLIENT ID HAS NOT, THIS IS AN ANOMALY...  STOPPING..  "
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      exit 4
    else
      echo ""
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      echo " [createDroneOauthApp()] - BOTH CLIENT ID AND CLIENT SECRET WERE NOT CREATED : NOW ATTEMPTING TO CREATE THEM"
      echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    fi;
  fi;
  if [ "x${GITEA_POKUS_USER_ACCESS_TOKEN}" == "x" ]; then
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo " [createDroneOauthApp()] - GITEA_POKUS_USER_ACCESS_TOKEN  is not set, but should be to be able to authenticate against the Gitea API"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo ""
    exit 2
  fi;



  sleep 5s
  # --- #
  # CREATE GITEA API TOKEN:
  #   - must wait for gitea appi to be up...(healthcheck ?)
  # --- #
  # exact username and password used to login with gitea webui
  export GITEA_DRONEUSER_NAME=${POKUS_ADMIN_USER:-"jean.baptiste.lasselle@gmail.com"}
  export GITEA_DRONEUSER_PWD=${POKUS_ADMIN_PASSWORD:-"vitefait7777"}
  # curl -X POST -H "Content-Type: application/json"  -k -d '{"name":"dronelab"}' -u ${GITEA_DRONEUSER_NAME}:${GITEA_DRONEUSER_PWD} https://try.gitea.io/api/v1/users/${GITEA_DRONEUSER_NAME}/tokens | tee ./.my.gitea.api.token.json | jq .
  # # -- the following values worked, to test on live demo gitea:
  # # export GITEA_DRONEUSER_NAME="jean.baptiste.lasselle@gmail.com"
  # # export GITEA_DRONEUSER_PWD="vitefait7777"
  # # curl -X POST -H "Content-Type: application/json"  -k -d '{"name":"dronelab"}' -u ${GITEA_DRONEUSER_NAME}:${GITEA_DRONEUSER_PWD} https://try.gitea.io/api/v1/users/${GITEA_DRONEUSER_NAME}/tokens | tee ./.my.gitea.api.token.json | jq .

  # cat ./.my.gitea.api.token.json | jq .

  # cat ./.my.gitea.api.token.json | jq .sha1

  # cat ./.my.gitea.api.token.json | jq .sha1 | awk -F '"' '{print $2}'

  # export GITEA_API_TOKEN=$(cat ./.my.gitea.api.token.json | jq .sha1 | awk -F '"' '{print $2}')
  # On try.gitea.io i got : Powered by Gitea Version: 1.16.0+dev-345-gf2a5d1b42
  export GITEA_API_TOKEN=${GITEA_POKUS_USER_ACCESS_TOKEN}
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createDroneOauthApp()] - GITEA_API_TOKEN=[${GITEA_API_TOKEN}]"
  echo " [createDroneOauthApp()] - GITEA_POKUS_USER_ACCESS_TOKEN=[${GITEA_POKUS_USER_ACCESS_TOKEN}]"
  echo " [createDroneOauthApp()] - POKUS_GITEA_SERVER_HTTP_PROTO=[${POKUS_GITEA_SERVER_HTTP_PROTO}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
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
  export DRONE_GITEA_APP_NAME="droneapp"
  export DRONE_GITEA_REDIRECT_URI=${DRONE_GITEA_REDIRECT_URI:-"https://drone.pok-us.io/login"}
  export POKUS_GITEA_SERVER_HTTP_PROTO=${POKUS_GITEA_SERVER_HTTP_PROTO:-"https"}
  export GITEA_API_ENDPOINT="${POKUS_GITEA_SERVER_HTTP_PROTO}://0.0.0.0:3000/api/v1/user/applications/oauth2"
  export JSON_PAYLOAD="{
    \"name\": \"${DRONE_GITEA_APP_NAME}\",
    \"redirect_uris\": [
      \"${DRONE_GITEA_REDIRECT_URI}\"
    ]
  }"

  export VERB_API_REQUEST="curl -X 'POST' ${GITEA_API_ENDPOINT} -H 'Authorization: token ${GITEA_API_TOKEN}' -H 'accept: application/json' -H 'Content-Type: application/json' -d \"${JSON_PAYLOAD}\" | tee ./.gitea.user.ssh.keys.json | jq ."


  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createDroneOauthApp()] - HTTP REQUEST  TO GITEA API: "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "#    VERB_API_REQUEST=[${VERB_API_REQUEST}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  # this request agains Gitea API to create oauth app extremely well works
  curl -X 'POST' \
    ${GITEA_API_ENDPOINT} \
    -H "Authorization: token ${GITEA_API_TOKEN}" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d "${JSON_PAYLOAD}" | tee ./.gitea.ouath.drone-app.json | jq .


  cat ./.gitea.ouath.drone-app.json | jq .
  # --
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createDroneOauthApp()] - HTTP RESPONSE OF GITEA API TO CREATE GITEA OAUTH2 APP FOR DRONE : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  cat ./.gitea.ouath.drone-app.json | jq .
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  export DRONE_GITEA_CLIENT_ID=$(cat ./.gitea.ouath.drone-app.json | jq .)
  export DRONE_GITEA_CLIENT_SECRET=$(cat ./.gitea.ouath.drone-app.json | jq .)


  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createDroneOauthApp()] - GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}] "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/dev/drone/
  # echo "${DRONE_GITEA_CLIENT_ID}" > ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_id
  # echo "${DRONE_GITEA_CLIENT_SECRET}" > ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_secret
  # ---  # ---  # ---  # ---
  # Form of the returned JSON when successfully created the Gitea Oauth 2 Application :
  # ---  # ---  # ---  # ---
  #   {
  #     "id": 153,
  #     "name": "droneapp",
  #     "client_id": "c139d3c0-6a47-4832-aa0a-b470433a6a00",
  #     "client_secret": "fMpVnvblQyZTqYFQSVO1FbdwSu3V80ZFEHVfU73ahT8J",
  #     "redirect_uris": [
  #       "https://voila.koi/oula/daccord"
  #     ],
  #     "created": "2021-10-12T00:03:36Z"
  #   }
  # ---  # ---  # ---  # ---
  # Finally note: https://docs.gitea.io/en-us/api-usage/#sudo
  # > The API allows admin users to sudo API requests as another user. Simply add either a sudo= parameter or Sudo: request header with the username of the user to sudo.
  # ---  # ---  # ---  # ---
  # -- >>> VAULT
  # vault kv put pokus.secrets/dev/gitea/api token=${GITEA_API_TOKEN}
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/dev/gitea/
  echo "${GITEA_API_TOKEN}" > ${GITEA_SHARED_SECRETS_HOME}/dev/gitea/api.token
  # # -> Also add the secrets for the gitea/drone integration (creating autpmatically the lcient id client secrets for gitea, before configuring and launching drone ?
  # vault kv put pokus.secrets/dev/drone/gitea client_id=${DRONE_GITEA_CLIENT_ID}
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/dev/drone/
  echo "${DRONE_GITEA_CLIENT_ID}" > ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_id
  # # -> Also add the secrets for the gitea/drone integration (creating autpmatically the lcient id client secrets for gitea, before configuring and launching drone ?
  # vault kv put pokus.secrets/dev/drone/gitea client_secret=${DRONE_GITEA_CLIENT_SECRET}
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/dev/drone/
  echo "${DRONE_GITEA_CLIENT_SECRET}" > ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_secret
  # # -> Also add the secrets for the gitea first admin user, directly used by drone (w should create a non admin user instead in gitea, for dorne, and create a gitea api token and a gitea oauth2 application from that non-admin user)
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/dev/gitea/
  echo "${GITEA_DRONEUSER_NAME}" > ${GITEA_SHARED_SECRETS_HOME}/dev/gitea/user.name
  # vault kv put pokus.secrets/dev/gitea/user name=${GITEA_FIRST_USER_NAME}
  echo "${GITEA_DRONEUSER_PWD}" > ${GITEA_SHARED_SECRETS_HOME}/dev/gitea/user.password
  # vault kv put pokus.secrets/dev/gitea/user password=${GITEA_FIRST_USER_PWD}

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createDroneOauthApp()] - Finished persisting secrets in [${GITEA_SHARED_SECRETS_HOME}] "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createDroneOauthApp()] - Check Content of : "
  echo " [${GITEA_SHARED_SECRETS_HOME}] "
  echo " [${GITEA_SHARED_SECRETS_HOME}/dev] "
  echo " [${GITEA_SHARED_SECRETS_HOME}/dev/drone] "
  echo " [${GITEA_SHARED_SECRETS_HOME}/dev/gitea] "
  echo " [${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_id] "
  echo " [${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_secret] "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  #
  ls -alh ${GITEA_SHARED_SECRETS_HOME}
  ls -alh ${GITEA_SHARED_SECRETS_HOME}/dev
  ls -alh ${GITEA_SHARED_SECRETS_HOME}/dev/drone
  ls -alh ${GITEA_SHARED_SECRETS_HOME}/dev/gitea
  ls -alh ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_id
  ls -alh ${GITEA_SHARED_SECRETS_HOME}/dev/drone/gitea.client_secret
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

}

trustReverseProxyTLSRootCA () {
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "#  [trustReverseProxyTLSRootCA () - CHECK - POKUS_GITEA_REV_PROXY_ROOT_CA_CERT=[${POKUS_GITEA_REV_PROXY_ROOT_CA_CERT}]]"
  echo "#  [trustReverseProxyTLSRootCA () - CHECK - if POKUS_GITEA_REV_PROXY_ROOT_CA_CERT=[${POKUS_GITEA_REV_PROXY_ROOT_CA_CERT}] exists as a file] : "
  # check if file does exists, it should exists as soon as the caddy cotnaienr is up n running
  # ls -alh /pokus/caddy/pki/authorities/local/root.crt
  # export POKUS_GITEA_REV_PROXY_ROOT_CA_CERT=/pokus/caddy/pki/authorities/local/root.crt
  ls -alh ${POKUS_GITEA_REV_PROXY_ROOT_CA_CERT}
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  # then just trust the caddy root ca

  cp /pokus/caddy/pki/authorities/local/root.crt /usr/local/share/ca-certificates/caddy-root-ca.crt

  update-ca-certificates

}

chmod +x /app/gitea/gitea

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "JBL TEST [/donnees/gitea/.ssh/known_hosts]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [netstat -tulpn]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

netstat -tulpn


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
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 22 127.0.0.1]"
ssh-keyscan -vvv -t rsa -p 22 127.0.0.1 >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 22 0.0.0.0]"
ssh-keyscan -vvv -t rsa -p 22 0.0.0.0 >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 2222 0.0.0.0]"
ssh-keyscan -vvv -t rsa -p 2222 0.0.0.0 >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"


echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 22 gitea_server]"
ssh-keyscan -vvv -t rsa -p 22 gitea_server >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 2222 gitea_server]"
ssh-keyscan -vvv -t rsa -p 2222 gitea_server >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -t rsa -p 22 github.com]"
ssh-keyscan -vvv -t rsa -p 22 github.com >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"



echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo " Content of : [/donnees/gitea/.ssh/known_hosts]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

cat /donnees/gitea/.ssh/known_hosts

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

ls -alh /data
ls -alh /data/git
ls -alh /donnees/gitea/.ssh
ls -alh /donnees/gitea/.ssh/known_hosts
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"


echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "  CONTENT OF [/app/gitea/gitea] !!! "
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
ls -alh /app/gitea/gitea
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"


# ---
# To fix permission denied in the container, which
# causes the gitea server to fail at start-up (coudl also create a special user, but i think a 'gitea' linux user must already exist)
chown -R root:root /donnees
chmod -R a+rw /donnees
# mkdir -p /donnees/gitea/attachements
# ls -alh /donnees/gitea/attachements

ATTEMPT=0
MAX_ATTEMPT=60
while true; do
    sleep 3s
    ATTEMPT=$(($ATTEMPT + 1))
    unset GITEA_STATUS_CODE
    export GITEA_STATUS_CODE=$(curl -I 0.0.0.0:3000 -o /dev/null -w '%{http_code}\n' -s)
    echo "# >>>>++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "  >> POLLING GITEA >> TEST GITEA_STATUS_CODE=[${GITEA_STATUS_CODE}] <<<<<< "
    echo "  >> POLLING GITEA >> TEST [curl -ivvv -I 0.0.0.0:3000 -w '%{http_code}\n'] <<<<<< "
    curl -ivvv -I 0.0.0.0:3000 -w '%{http_code}\n'
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# >>>>++++++++++++++++++++++++++++++ #"


    unset CADDY_STATUS_CODE
    export CADDY_STATUS_CODE=$(curl -I https://$DOMAIN -o /dev/null -w '%{http_code}\n' -s)
    echo "# >>>>++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "  >> POLLING GITEA >> TEST DOMAIN=[${DOMAIN}] <<<<<< "
    echo "  >> POLLING GITEA >> TEST CADDY_STATUS_CODE=[${CADDY_STATUS_CODE}] <<<<<< "
    echo "  >> POLLING GITEA >> TEST [curl -ivvv -I https://$DOMAIN -w '%{http_code}\n'] <<<<<< "
    curl -ivvv -I https://$DOMAIN -w '%{http_code}\n'
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++ This request is meant to run across the docker host "
    echo "# ++++++++++++ network: ${DOMAIN} resolves to the IP_ADDR of the "
    echo "# ++++++++++++ Docker hosts, thanks to the [extra_hosts] directive of "
    echo "# ++++++++++++ the [gitea_server] service, in the [docker-compose.yml]"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# >>>>++++++++++++++++++++++++++++++ #"


    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ---   [BEFORE IF IN - LOOP TO DETECT GITEA STARTED] - ATTEMPT No. : [${ATTEMPT}]]"
    echo "# +++++           "
    echo "# ---   [BEFORE IF IN - LOOP TO DETECT GITEA STARTED] - GITEA_STATUS_CODE=[${GITEA_STATUS_CODE}]]"
    echo "# ---   [BEFORE IF IN - LOOP TO DETECT GITEA STARTED] - CADDY_STATUS_CODE=[${CADDY_STATUS_CODE}]]"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

    # if [ $GITEA_STATUS_CODE = "405" ]; then
    # if [ $GITEA_STATUS_CODE = "302" ]; then
    if [ $GITEA_STATUS_CODE = "200" ]; then

        if [ $GITEA_STATUS_CODE = "200" ]; then
          # -- We wait until both Caddy and Gitea are ready, before running te initialization of the server.
          echo "Gitea is ready"
          echo "# -------------------------------------------------------------------------------- #"
          echo "# ---   [LOOP TO DETECT GITEA STARTED] - Create Gitea firsts super admin user"
          echo "# -------------------------------------------------------------------------------- #"

          # gitea admin create-user --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email your@email.org --must-change-password=false && createDroneOauthApp
          echo "# >>>>++++++++++++++++++++++++++++++ #"
          echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
          echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
          echo "  CREATE INIT SUPER ADMIIN USER <<<<<< "
          echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
          echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
          echo "# >>>>++++++++++++++++++++++++++++++ #"
          # this command cannot be executed as long as the gitea install webui button is pressed...
          # gitea admin user create --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email pokus@pokus-io.org --access-token pokusdrone | tee ./gitea.cli.stdout
          gitea admin user create --admin --username $POKUS_ADMIN_USER --password=$POKUS_ADMIN_PASSWORD --email=pokus@pokus-io.org --access-token=true --must-change-password=false | tee ./gitea.cli.stdout
          export GITEA_POKUS_USER_ACCESS_TOKEN=$(cat ./gitea.cli.stdout | grep 'Access token was successfully created... ' | awk -F 'Access token was successfully created... ' '{print $2}')
          echo "# -------------------------------------------------------------------------------- #"
          echo "# ---   [LOOP TO DETECT GITEA STARTED] - GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]  "
          echo "# ---   [LOOP TO DETECT GITEA STARTED] - GITEA_POKUS_USER_ACCESS_TOKEN=[${GITEA_POKUS_USER_ACCESS_TOKEN}]  "
          echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
          echo "# ---   [LOOP TO DETECT GITEA STARTED] - POKUS_GITEA_REV_PROXY_ROOT_CA_CERT=[${POKUS_GITEA_REV_PROXY_ROOT_CA_CERT}]]"
          echo "# ---   [LOOP TO DETECT GITEA STARTED] - GITEA_STATUS_CODE=[${GITEA_STATUS_CODE}]]"
          echo "# ---   [LOOP TO DETECT GITEA STARTED] - CADDY_STATUS_CODE=[${CADDY_STATUS_CODE}]]"
          echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

          echo "# -------------------------------------------------------------------------------- #"
          mkdir -p ${GITEA_SHARED_SECRETS_HOME}/dev/gitea/
          echo "${GITEA_POKUS_USER_ACCESS_TOKEN}" > ${GITEA_SHARED_SECRETS_HOME}/dev/gitea/api.token
          echo "# >>>>++++++++++++++++++++++++++++++ #"
          echo "# >>>>++++++++++++++++++++++++++++++ #"
          rm ./gitea.cli.stdout
          createDroneOauthApp && addSsshKeyToGiteaUser && trustReverseProxyTLSRootCA
          exit 0
        elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
            exit 1
          # --
        fi;
    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    fi;
done & /usr/bin/entrypoint
