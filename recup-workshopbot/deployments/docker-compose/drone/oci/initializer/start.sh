#!/bin/bash


export POKUS_CHAT_SERVER_HOSTNAME=rocketchat
export POKUS_CHAT_SERVER_HOSTNAME=${POKUS_CHAT_SERVER_HOSTNAME}
export POKUS_CHAT_SERVER_PORT=3000
export POKUS_CHAT_SERVER_PORT=${POKUS_CHAT_SERVER_PORT}
export POKUS_CHAT_SERVER_HTTP_PROTO=http
export POKUS_CHAT_SERVER_HTTP_PROTO=${POKUS_CHAT_SERVER_HTTP_PROTO:-"https"}

echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"
echo "# --- Here the [rocketchat_init] goes on in [/bin/bash]"
echo "# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #"

# --- # --- # --- # --- # --- # --- #
# -- this function hits the rocketchat api to create the user
createHubotUser () {
  # --
  # --
  # -- https://developer.rocket.chat/reference/api/rest-api/endpoints/other-important-endpoints/authentication-endpoints
  # -- https://developer.rocket.chat/reference/api/rest-api/endpoints/team-collaboration-endpoints/users-endpoints/create-user-endpoint
  # -- https://developer.rocket.chat/reference/api/rest-api/endpoints/other-important-endpoints/authentication-endpoints/login
  # -- https://developer.rocket.chat/reference/api/rest-api/endpoints/team-collaboration-endpoints/users-endpoints/get-users-list



  export POKUS_CHAT_ADMIN_USER_NAME=${POKUS_CHAT_ADMIN_USER_NAME}
  export POKUS_CHAT_ADMIN_USER_PWD=${POKUS_CHAT_ADMIN_USER_PWD}
  # Note: https://developer.rocket.chat/reference/api/rest-api/endpoints/team-collaboration-endpoints/users-endpoints/create-user-endpoint
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- "
  echo "### --- --- --- --- BEGINNING OF createHubotUser ()"
  echo "### --- "
  echo "### ---   POKUS_CHAT_ADMIN_USER_NAME=[${POKUS_CHAT_ADMIN_USER_NAME}]"
  echo "### ---   POKUS_CHAT_ADMIN_USER_PWD=[${POKUS_CHAT_ADMIN_USER_PWD}]"
  echo "### ---"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"


  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- createHubotUser ()"
  echo "### --- FIRST AUTHENTICATE TO REST API ROCKETCHAT REST API :"
  echo "### ---"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  # THE PURPOSE OF THIS PART IS TO
  # GET THE USER ID AND AUTH TOKEN WE NEED
  # TO CONSUME ALL AUTH REQUIRED ENDPOINTS OF THE
  # ROCKET CHAT API
  # ----
  if [ "x${POKUS_CHAT_SERVER_PORT}" == "x" ]; then
    echo "# explain here"
    export POKUS_CHAT_ENDPOINT="${POKUS_CHAT_SERVER_HTTP_PROTO}://${POKUS_CHAT_SERVER_HOSTNAME}/api/v1/login"
  else
    echo "# explain here"
    export POKUS_CHAT_ENDPOINT="${POKUS_CHAT_SERVER_HTTP_PROTO}://${POKUS_CHAT_SERVER_HOSTNAME}:${POKUS_CHAT_SERVER_PORT}/api/v1/login"
  fi;
  # You MUST provide either user AND password, or provide resume.
  export RAW_PAYLOAD="{
    \"user\": \"${POKUS_CHAT_ADMIN_USER_NAME}\",
    \"resume\": \"9HqLlyZOugoStsXCUfD_0YdwnNnunAJF8V47U3QHXSq\",
    \"password\": \"${POKUS_CHAT_ADMIN_USER_PWD}\"
  }"

  export RAW_PAYLOAD="user=${POKUS_CHAT_ADMIN_USER_NAME}&password=${POKUS_CHAT_ADMIN_USER_PWD}"


  # This request against RocketChat API to login
  export HTTP_RESP_CODE_WAS=$(curl -X 'POST' \
    ${POKUS_CHAT_ENDPOINT} \
    -H 'accept: application/json' \
    -w '%{http_code}\n' \
    -d "${RAW_PAYLOAD}" | tee ./.rocketchat.api.auth.json | jq .)

  export HTTP_RESP_CODE_WAS=$(echo "${HTTP_RESP_CODE_WAS}" | tail -n 1)

  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- createHubotUser ()"
  echo "### --- AUTH - JSON RESPONSE OF REST API ROCKETCHAT API :"
  echo "### ---"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  cat ./.rocketchat.api.auth.json
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  cat ./.rocketchat.api.auth.json | jq .
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"

  # --
  # --
  # --
  # --
  # --
  # --
  export VERB_API_REQUEST="curl -X 'POST' ${POKUS_CHAT_ENDPOINT} -H 'accept: application/json' -d \"${RAW_PAYLOAD}\" | jq ."

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createHubotUser()] - HTTP REQUEST TO ROCKETCHAT API TO LOGIN : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "#    VERB_API_REQUEST=[${VERB_API_REQUEST}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "#    HTTP RESPONSE CODE WAS : [${HTTP_RESP_CODE_WAS}] "
  echo "#    HTTP RESPONSE WAS : "
  cat ./.rocketchat.api.auth.json | jq .
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"



  export POKUS_CHAT_API_USER_ID=$(cat ./.rocketchat.api.auth.json | jq .data.userId | awk -F '"' '{print $2}')
  export POKUS_CHAT_API_TOKEN=$(cat ./.rocketchat.api.auth.json | jq .data.authToken | awk -F '"' '{print $2}')
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- createHubotUser ()"
  echo "### --- POKUS_CHAT_API_USER_ID=[${POKUS_CHAT_API_USER_ID}]"
  echo "### --- POKUS_CHAT_API_TOKEN=[${POKUS_CHAT_API_TOKEN}]"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"

  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- createHubotUser ()"
  echo "### --- NOW WE CHECK IF THE ROCKETCHAT USER HAS ALREADY BEEN CREATED (idempotence)"
  echo "### ---"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  # https://developer.rocket.chat/reference/api/rest-api/endpoints/team-collaboration-endpoints/users-endpoints/get-users-list

  if [ "x${POKUS_CHAT_SERVER_PORT}" == "x" ]; then
    echo "# explain here"
    export POKUS_CHAT_ENDPOINT="${POKUS_CHAT_SERVER_HTTP_PROTO}://${POKUS_CHAT_SERVER_HOSTNAME}/api/v1/users.list"
  else
    echo "# explain here"
    export POKUS_CHAT_ENDPOINT="${POKUS_CHAT_SERVER_HTTP_PROTO}://${POKUS_CHAT_SERVER_HOSTNAME}:${POKUS_CHAT_SERVER_PORT}/api/v1/users.list"
  fi;
  # ---
  # this request against RocketChat API to check if the ${POKUS_CHAT_BOT_USER_NAME} user already exists in Rocket Chat. (has already been created)
  export HTTP_RESP_CODE_WAS=$(curl -X 'GET' \
    ${POKUS_CHAT_ENDPOINT} \
    -H "X-Auth-Token: ${POKUS_CHAT_API_TOKEN}" \
    -H "X-User-Id: ${POKUS_CHAT_API_USER_ID}" \
    -H 'accept: application/json' \
    -w '%{http_code}\n' \
    -H 'Content-Type: application/json' | tee ./.rocketchat.api.check.user.json | jq .)
  export HTTP_RESP_CODE_WAS=$(echo "${HTTP_RESP_CODE_WAS}" | tail -n 1)
  cat ./.rocketchat.api.check.user.json | jq .

  # --
  # --
  # --
  # --
  # --
  # --
  export VERB_API_REQUEST="curl -X 'GET' ${POKUS_CHAT_ENDPOINT} -H \"X-Auth-Token: ${POKUS_CHAT_API_TOKEN}\" -H \"X-User-Id: ${POKUS_CHAT_API_USER_ID}\" -H 'accept: application/json' -H 'Content-Type: application/json' | jq ."


  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createHubotUser()] - HTTP REQUEST TO ROCKETCHAT API TO CHECK IF HUBOT "
  echo " [createHubotUser()] - USER WAS ALREADY CREATED IN ROCKETCHAT : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# --- createHubotUser () VERB_API_REQUEST=[${VERB_API_REQUEST}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# --- createHubotUser () HTTP RESPONSE CODE WAS : [${HTTP_RESP_CODE_WAS}] "
  echo "# --- createHubotUser () HTTP RESPONSE WAS : "
  cat ./.rocketchat.api.check.user.json | jq .
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  # there must be at worst case 3 RocketChat users, so we must find the hubot user among them
  export CHECK_POKUS_CHAT_API_USERNAME=$(cat ./.rocketchat.api.check.user.json | jq .users[0].username | awk -F '"' '{print $2}')
  # bot role must be the ony one role for the hubot as a rocketchat user
  export CHECK_POKUS_CHAT_API_USER_TYPE=$(cat ./.rocketchat.api.check.user.json | jq .users[0].roles[0] | awk -F '"' '{print $2}')
  export CHECK1_POKUS_CHAT_API_USERNAME=$(cat ./.rocketchat.api.check.user.json | jq .users[1].username | awk -F '"' '{print $2}')
  # bot role must be the ony one role for the hubot as a rocketchat user
  export CHECK1_POKUS_CHAT_API_USER_TYPE=$(cat ./.rocketchat.api.check.user.json | jq .users[1].roles[0] | awk -F '"' '{print $2}')
  export CHECK2_POKUS_CHAT_API_USERNAME=$(cat ./.rocketchat.api.check.user.json | jq .users[2].username | awk -F '"' '{print $2}')
  # bot role must be the ony one role for the hubot as a rocketchat user
  export CHECK2_POKUS_CHAT_API_USER_TYPE=$(cat ./.rocketchat.api.check.user.json | jq .users[2].roles[0] | awk -F '"' '{print $2}')

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# --- createHubotUser () - CHECK_POKUS_CHAT_API_USERNAME=[${CHECK_POKUS_CHAT_API_USERNAME}]"
  echo "# --- createHubotUser () - CHECK_POKUS_CHAT_API_USER_TYPE=[${CHECK_POKUS_CHAT_API_USER_TYPE}]"
  echo "# --- createHubotUser () - CHECK_POKUS_CHAT_API_USERNAME=[${CHECK_POKUS_CHAT_API_USERNAME}]"
  echo "# --- createHubotUser () - CHECK1_POKUS_CHAT_API_USERNAME=[${CHECK1_POKUS_CHAT_API_USERNAME}]"
  echo "# --- createHubotUser () - CHECK2_POKUS_CHAT_API_USERNAME=[${CHECK2_POKUS_CHAT_API_USERNAME}]"
  echo "# --- createHubotUser () - POKUS_CHAT_BOT_USER_NAME=[${POKUS_CHAT_BOT_USER_NAME}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  if [ "${CHECK_POKUS_CHAT_API_USERNAME}" == "${POKUS_CHAT_BOT_USER_NAME}" ]; then
    echo "### --- createHubotUser ()  The [${POKUS_CHAT_BOT_USER_NAME}] ROCKETCHAT USER ALREADY EXISTS !!! (SO WILL NOT CREATE IT)"
    export ATTEMPT=59
    if ! [ "${CHECK_POKUS_CHAT_API_USER_TYPE}" == "bot" ]; then
      echo "# --- createHubotUser () - THE HUBOT ROCKETCHAT USER SHOULD BE OF TYPE 'bot' but CHECK_POKUS_CHAT_API_USER_TYPE=[${CHECK_POKUS_CHAT_API_USER_TYPE}]"
      exit 3
    fi;
    exit 0
  else
    echo "### --- createHubotUser ()  The CHECK_POKUS_CHAT_API_USERNAME=[${CHECK_POKUS_CHAT_API_USERNAME}] value is not equal to POKUS_CHAT_BOT_USER_NAME=[${POKUS_CHAT_BOT_USER_NAME}]"
  fi;

  if [ "${CHECK1_POKUS_CHAT_API_USERNAME}" == "${POKUS_CHAT_BOT_USER_NAME}" ]; then
    echo "### --- createHubotUser ()  The [${POKUS_CHAT_BOT_USER_NAME}] ROCKETCHAT USER ALREADY EXISTS !!! (SO WILL NOT CREATE IT)"
    if ! [ "${CHECK1_POKUS_CHAT_API_USER_TYPE}" == "bot" ]; then
      echo "# --- createHubotUser () - THE HUBOT ROCKETCHAT USER SHOULD BE OF TYPE 'bot' but CHECK1_POKUS_CHAT_API_USER_TYPE=[${CHECK1_POKUS_CHAT_API_USER_TYPE}]"
      exit 3
    fi;
    export ATTEMPT=59
    exit 0
  else
    echo "### --- createHubotUser ()  The CHECK1_POKUS_CHAT_API_USERNAME=[${CHECK1_POKUS_CHAT_API_USERNAME}] value is not equal to POKUS_CHAT_BOT_USER_NAME=[${POKUS_CHAT_BOT_USER_NAME}]"
  fi;

  if [ "${CHECK2_POKUS_CHAT_API_USERNAME}" == "${POKUS_CHAT_BOT_USER_NAME}" ]; then
    echo "### --- createHubotUser ()  The [${POKUS_CHAT_BOT_USER_NAME}] ROCKETCHAT USER ALREADY EXISTS !!! (SO WILL NOT CREATE IT)"
    if ! [ "${CHECK2_POKUS_CHAT_API_USER_TYPE}" == "bot" ]; then
      echo "# --- createHubotUser () - THE HUBOT ROCKETCHAT USER SHOULD BE OF TYPE 'bot' but CHECK2_POKUS_CHAT_API_USER_TYPE=[${CHECK2_POKUS_CHAT_API_USER_TYPE}]"
      exit 3
    fi;
    export ATTEMPT=59
    exit 0
  else
    echo "### --- createHubotUser ()  The CHECK2_POKUS_CHAT_API_USERNAME=[${CHECK2_POKUS_CHAT_API_USERNAME}] value is not equal to POKUS_CHAT_BOT_USER_NAME=[${POKUS_CHAT_BOT_USER_NAME}]"
  fi;


  # Now we know The bot user has not been created
  echo "### --- createHubotUser ()  The [${POKUS_CHAT_BOT_USER_NAME}] ROCKETCHAT USER DOES NOT EXISTS !!! (SO WILL CREATE IT)"


  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"



  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- createHubotUser ()"
  echo "### ---"
  echo "### --- THEN CREATE THE HUBOT USER BY HITTING ROCKETCHAT REST API :"
  echo "### ---"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"
  echo "### --- ### --- ### --- ### --- ### --- ### --- ###"

  if [ "x${POKUS_CHAT_SERVER_PORT}" == "x" ]; then
    echo "# explain here"
    export POKUS_CHAT_ENDPOINT="${POKUS_CHAT_SERVER_HTTP_PROTO}://${POKUS_CHAT_SERVER_HOSTNAME}/api/v1/users.create"
  else
    echo "# explain here"
    export POKUS_CHAT_ENDPOINT="${POKUS_CHAT_SERVER_HTTP_PROTO}://${POKUS_CHAT_SERVER_HOSTNAME}:${POKUS_CHAT_SERVER_PORT}/api/v1/users.create"
  fi;

  export JSON_PAYLOAD="{
    \"name\": \"${POKUS_CHAT_BOT_USER_NAME}\",
    \"username\": \"${POKUS_CHAT_BOT_USER_ALIAS}\",
    \"email\": \"${POKUS_CHAT_BOT_USER_EMAIL}\",
    \"password\": \"${POKUS_CHAT_BOT_USER_PWD}\",
    \"roles\": [ \"bot\" ]
  }"

  # this request agains Gitea API to create oauth app extremely well works
  export HTTP_RESP_CODE_WAS=$(curl -X 'POST' \
    ${POKUS_CHAT_ENDPOINT} \
    -H "X-Auth-Token: ${POKUS_CHAT_API_TOKEN}" \
    -H "X-User-Id: ${POKUS_CHAT_API_USER_ID}" \
    -H 'accept: application/json' \
    -w '%{http_code}\n' \
    -H 'Content-Type: application/json' \
    -d "${JSON_PAYLOAD}" | tee ./.rocketchat.api.created.user.json | jq .)

  export LASTLINE_OF_HTTPRESP=$(cat ./.rocketchat.api.created.user.json | tail -n 1 )
  cat ./.rocketchat.api.created.user.json | grep -v "'${LASTLINE_OF_HTTPRESP}'" | tee ./.rocketchat.api.created.user.json
  cat ./.rocketchat.api.created.user.json | jq .

  export HTTP_RESP_CODE_WAS=$(echo "${HTTP_RESP_CODE_WAS}" | tail -n 1)
  # --
  # --
  # --
  # --
  # --
  # --
  export VERB_API_REQUEST="curl -X 'POST' ${POKUS_CHAT_ENDPOINT} -H \"X-Auth-Token: ${POKUS_CHAT_API_TOKEN}\" -H \"X-User-Id: ${POKUS_CHAT_API_USER_ID}\" -H 'accept: application/json' -H 'Content-Type: application/json' -d \"${JSON_PAYLOAD}\" | jq ."
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [createHubotUser()] - HTTP REQUEST TO ROCKETCHAT API TO CREATE THE HUBOT USER: "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "#    VERB_API_REQUEST=[${VERB_API_REQUEST}]"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "#    HTTP RESPONSE CODE WAS : [${HTTP_RESP_CODE_WAS}] "
  echo "#    HTTP RESPONSE WAS : "
  cat ./.rocketchat.api.created.user.json | jq .
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"


}

# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
# echo "#  [netstat -tulpn]"
# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

# netstat -tulpn

echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
# echo "# >>>>++++++++++++++++++++++++++++++ #"
# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
# echo "#  [Check - /data/rocketchat-init/pki/authorities/local/root.crt]"
# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
# echo "#  [Content of - /data/]"
# ls -alh /data/ || true
# echo "#  [Content of - /data/rocketchat-init/]"
# ls -alh /data/rocketchat-init/ || true
# echo "#  [Content of - /data/rocketchat-init/pki/]"
# ls -alh /data/rocketchat-init/pki/ || true
# echo "#  [Content of - /data/rocketchat-init/pki/authorities/]"
# ls -alh /data/rocketchat-init/pki/authorities/ || true
# echo "#  [Content of - /data/rocketchat-init/pki/authorities/local/]"
# ls -alh /data/rocketchat-init/pki/authorities/local/ || true
# echo "#  [Existence of - /data/rocketchat-init/pki/authorities/local/root.crt]"
# ls -alh /data/rocketchat-init/pki/authorities/local/root.crt || true
# echo "#  [Existence of - /data/rocketchat-init/pki/authorities/local/root.key]"
# ls -alh /data/rocketchat-init/pki/authorities/local/root.key || true
# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo ''
echo ''
echo ''


ATTEMPT=0
MAX_ATTEMPT=60
while true; do
    sleep 1
    ATTEMPT=$(($ATTEMPT + 1))
    unset STATUS_CODE
    export STATUS_CODE=$(curl -I ${POKUS_CHAT_SERVER_HOSTNAME}:${POKUS_CHAT_SERVER_PORT} -o /dev/null -w '%{http_code}\n' -s)
    echo "# >>>>++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "  TEST STATUS_CODE=[${STATUS_CODE}] <<<<<< "
    echo "  TEST [curl -ivvv -I ${POKUS_CHAT_SERVER_HOSTNAME}:${POKUS_CHAT_SERVER_PORT} -w '%{http_code}\n'] <<<<<< "
    curl -ivvv -I ${POKUS_CHAT_SERVER_HOSTNAME}:${POKUS_CHAT_SERVER_PORT} -w '%{http_code}\n'
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
    echo "# >>>>++++++++++++++++++++++++++++++ #"


    # if [ $STATUS_CODE = "405" ]; then
    # if [ $STATUS_CODE = "302" ]; then
    if [ $STATUS_CODE = "200" ]; then
        echo "Caddy is ready"
        echo "# -------------------------------------------------------------------------------- #"
        echo "# ---   [LOOP TO DETECT ROCKETCHAT STARTED] - create ROCKETCHAT User for HUBOT"
        echo "# -------------------------------------------------------------------------------- #"

      	echo "# >>>>++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "  INITIAL ROCKETCHAT CONFIGURATION <<<<<< "
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
        # ----
        # This command cannot be executed as long as the rocketchat server is up n running, with its API
        createHubotUser
        echo "# -------------------------------------------------------------------------------- #"
        # echo "# ---   [LOOP TO DETECT ROCKETCHAT STARTED] - CCCC=[${CCCC}]  "
        echo "# -------------------------------------------------------------------------------- #"
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
        exit 0
    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    fi;
done
# done & /usr/bin/caddy.entrypoint
