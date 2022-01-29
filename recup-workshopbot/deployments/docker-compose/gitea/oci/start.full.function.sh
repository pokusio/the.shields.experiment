#!/bin/bash
createDroneOauthApp() {
  if [ [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/api.token ] && [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.client_id ] && [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.client_secret ] && [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/user.name ] && [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/user.password ] ]; then
    echo "The GITEA API TOKEN has already been created, and the Gitea Oauth2 Application for drone ci as well"
    exit 0
  else
    if [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/api.token ]; then
      if ! [ [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.client_id ] && [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.client_secret ] ]; then
        echo "The GITEA API TOKEN has already been created, but NOT the Gitea Oauth2 Application for drone ci as well"
      else
        echo "The GITEA API TOKEN has already been created, and the Gitea Oauth2 Application for drone ci as well"
        exit 0
      fi;
    else
      echo "The GITEA API TOKEN needs to be created, to be used to create the Gitea Oauth2 application, and ge the [client_secret] and [client_id] of that Gitea Oauth2 App"
    fi;
  fi;



  sleep 5s
  # --- #
  # CREATE GITEA API TOKEN:
  #   - must wait for gitea appi to be up...(healthcheck ?)
  # --- #
  # exact username and password used to login with gitea webui
  export GITEA_DRONEUSER_NAME=${GITEA_DRONEUSER_NAME:-"jean.baptiste.lasselle@gmail.com"}
  export GITEA_DRONEUSER_PWD=${GITEA_DRONEUSER_PWD:-"vitefait7777"}
  curl -X POST -H "Content-Type: application/json"  -k -d '{"name":"dronelab"}' -u ${GITEA_DRONEUSER_NAME}:${GITEA_DRONEUSER_PWD} https://try.gitea.io/api/v1/users/${GITEA_DRONEUSER_NAME}/tokens | tee ./.my.gitea.api.token.json | jq .
  # -- the following values worked, to test on live demo gitea:
  # export GITEA_DRONEUSER_NAME="jean.baptiste.lasselle@gmail.com"
  # export GITEA_DRONEUSER_PWD="vitefait7777"
  # curl -X POST -H "Content-Type: application/json"  -k -d '{"name":"dronelab"}' -u ${GITEA_DRONEUSER_NAME}:${GITEA_DRONEUSER_PWD} https://try.gitea.io/api/v1/users/${GITEA_DRONEUSER_NAME}/tokens | tee ./.my.gitea.api.token.json | jq .

  cat ./.my.gitea.api.token.json | jq .

  cat ./.my.gitea.api.token.json | jq .sha1

  cat ./.my.gitea.api.token.json | jq .sha1 | awk -F '"' '{print $2}'

  export GITEA_API_TOKEN=$(cat ./.my.gitea.api.token.json | jq .sha1 | awk -F '"' '{print $2}')
  # On try.gitea.io i got : Powered by Gitea Version: 1.16.0+dev-345-gf2a5d1b42

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
  export GITEA_API_HOST=${GITEA_API_HOST:-"try.gitea.io"}
  export GITEA_API_ENDPOINT=${GITEA_API_ENDPOINT:-"https://${GITEA_API_HOST}/api/v1/user/applications/oauth2"}
  export JSON_PAYLOAD="{
    \"name\": \"${DRONE_GITEA_APP_NAME}\",
    \"redirect_uris\": [
      \"${DRONE_GITEA_REDIRECT_URI}\"
    ]
  }"
  # this request agains Gitea API to create oauth app extremely well works
  curl -X 'POST' \
    ${GITEA_API_ENDPOINT} \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -H "Authorization: token ${GITEA_API_TOKEN}" \
    -d "${JSON_PAYLOAD}" | tee ./.gitea.ouath.drone-app.json | jq .

  cat ./.gitea.ouath.drone-app.json | jq .
  export DRONE_GITEA_CLIENT_ID=$(cat ./.gitea.ouath.drone-app.json | jq .)
  export DRONE_GITEA_CLIENT_SECRET=$(cat ./.gitea.ouath.drone-app.json | jq .)
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
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/
  echo "${GITEA_API_TOKEN}" > ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/api.token
  # # -> Also add the secrets for the gitea/drone integration (creating autpmatically the lcient id client secrets for gitea, before configuring and launching drone ?
  # vault kv put pokus.secrets/dev/drone/gitea client_id=${DRONE_GITEA_CLIENT_ID}
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/
  echo "${DRONE_GITEA_CLIENT_ID}" > ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.client_id
  # # -> Also add the secrets for the gitea/drone integration (creating autpmatically the lcient id client secrets for gitea, before configuring and launching drone ?
  # vault kv put pokus.secrets/dev/drone/gitea client_secret=${DRONE_GITEA_CLIENT_SECRET}
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/
  echo "${DRONE_GITEA_CLIENT_SECRET}" > ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/drone/gitea.client_secret
  # # -> Also add the secrets for the gitea first admin user, directly used by drone (w should create a non admin user instead in gitea, for dorne, and create a gitea api token and a gitea oauth2 application from that non-admin user)
  mkdir -p ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/
  echo "${GITEA_DRONEUSER_NAME}" > ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/user.name
  # vault kv put pokus.secrets/dev/gitea/user name=${GITEA_FIRST_USER_NAME}
  echo "${GITEA_DRONEUSER_PWD}" > ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/user.password
  # vault kv put pokus.secrets/dev/gitea/user password=${GITEA_FIRST_USER_PWD}
}

chmod +x /app/gitea/gitea

echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "JBL TEST [/donnees/gitea/.ssh/known_hosts]"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++ #"
echo "#  [netstat -tulpn]"
echo "# ++++++++++++++++++++++++++++++++++ #"

netstat -tulpn


echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "#  [Check - /donnees/gitea/.ssh/authorized_keys]"
echo "#  [Check - /donnees/gitea/.ssh/authorized_keys]"
echo "#  [Check - /donnees/gitea/.ssh/authorized_keys]"
echo "# ++++++++++++++++++++++++++++++++++ #"
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
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 22 127.0.0.1]"
ssh-keyscan -vvv -t rsa -p 22 127.0.0.1 >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 22 0.0.0.0]"
ssh-keyscan -vvv -t rsa -p 22 0.0.0.0 >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 2222 0.0.0.0]"
ssh-keyscan -vvv -t rsa -p 2222 0.0.0.0 >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++ #"


echo "# ++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 22 gitea_server]"
ssh-keyscan -vvv -t rsa -p 22 gitea_server >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -vvv -t rsa -p 2222 gitea_server]"
ssh-keyscan -vvv -t rsa -p 2222 gitea_server >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++ #"

echo "# ++++++++++++++++++++++++++++++++++ #"
echo " [ssh-keyscan -t rsa -p 22 github.com]"
ssh-keyscan -vvv -t rsa -p 22 github.com >> /donnees/gitea/.ssh/known_hosts || true
echo "# ++++++++++++++++++++++++++++++++++ #"



echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo " Content of : [/donnees/gitea/.ssh/known_hosts]"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"

cat /donnees/gitea/.ssh/known_hosts

echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"

ls -alh /data
ls -alh /data/git
ls -alh /donnees/gitea/.ssh
ls -alh /donnees/gitea/.ssh/known_hosts
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"


echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "  CONTENT OF [/app/gitea/gitea] !!! "
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
ls -alh /app/gitea/gitea
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"




ATTEMPT=0
MAX_ATTEMPT=20
while true; do
    if [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/api.token ]; then
      echo " The [$POKUS_ADMIN_USER] ahas already been created"
      if [ -f ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/api.token ]; then
        echo " The [$POKUS_ADMIN_USER] ahas already been created"
        exit 0;
      fi;
    fi;
    sleep 1
    ATTEMPT=$(($ATTEMPT + 1))
    STATUS_CODE=$(curl -LI localhost:3000 -o /dev/null -w '%{http_code}\n' -s)
    if [ $STATUS_CODE = "200" ]; then
        echo "Gitea is ready"
        echo "# -------------------------------------------------------------------------------- #"
        echo "# ---   [LOOP TO DETECT GITEA STARTED] - Create Gitea firts super admin user"
        echo "# -------------------------------------------------------------------------------- #"
        # gitea admin create-user --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email your@email.org --must-change-password=false && createDroneOauthApp
        gitea admin user create --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email pokus@pokus-io.org --access-token pokusdrone | tee ./gitea.cli.stdout
        export GITEA_POKUS_USER_ACCESS_TOKEN=(cat ./gitea.cli.stdout | grep 'Access token was successfully created... ' | awk -F 'Access token was successfully created... ' '{print $2}')
        echo "# -------------------------------------------------------------------------------- #"
        echo "# ---   [LOOP TO DETECT GITEA STARTED] - GITEA_SHARED_SECRETS_HOME=[${GITEA_SHARED_SECRETS_HOME}]  "
        echo "# ---   [LOOP TO DETECT GITEA STARTED] - GITEA_POKUS_USER_ACCESS_TOKEN=[${GITEA_POKUS_USER_ACCESS_TOKEN}]  "
        echo "# -------------------------------------------------------------------------------- #"
        mkdir -p ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/
        echo "${GITEA_POKUS_USER_ACCESS_TOKEN}" > ${GITEA_SHARED_SECRETS_HOME}/pokus.secrets/dev/gitea/api.token
        rm ./gitea.cli.stdout
        exit 0
    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    fi;
done & /usr/bin/entrypoint




cat << EOF > ./gitea.cli.stdout
Access token was successfully created... 23e0fa9d2d5cd187e5e9446c0f949bab9c360d72
New user 'niko8' has been successfully created!
EOF
cat ./gitea.cli.stdout | grep 'Access token was successfully created... ' | awk -F 'Access token was successfully created... ' '{print $2}'
