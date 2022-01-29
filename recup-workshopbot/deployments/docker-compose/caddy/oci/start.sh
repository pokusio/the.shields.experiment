#!/bin/sh
uploadConfigurationToCaddyNEUTREULIZED() {
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++ uploadConfigurationToCaddyNEUTREULIZED"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
}
uploadConfigurationToCaddy() {

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [uploadConfigurationToCaddy()] - TEST EXISTENCE OF [/pokus/run/caddy.json] file : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  ls -alh /pokus/run/caddy.json || exit 45
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [uploadConfigurationToCaddy()] - VIEW CONTENT OF [/pokus/run/caddy.json] file : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  cat /pokus/run/caddy.json || exit 45
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [uploadConfigurationToCaddy()] - HTTP REQUEST TO LOAD CADDY CONFIG : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [curl -ivvv 0.0.0.0:443/load -X POST -H \"Content-Type: application/json\" -d @caddy.json || true]"
  # This request against Caddy Server to upload the caddy.json configuration to the Caddy Server
  curl -ivvv 0.0.0.0:443/load -X POST -H "Content-Type: application/json" -d @caddy.json || true
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [uploadConfigurationToCaddy()] - HTTP REQUEST TO LOAD CADDY CONFIG : "
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
  echo " [curl -ivvv localhost:443/load -X POST -H \"Content-Type: application/json\" -d @caddy.json || true]"
  # This request against Caddy Server to upload the caddy.json configuration to the Caddy Server
  curl -ivvv localhost:443/load -X POST -H "Content-Type: application/json" -d @caddy.json || true
  echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

}

if [ "x${POKUS_CADDYFILE}" == "x" ]; then
  echo "Fatal Error: POKUS_CADDYFILE env var is not defined"
  exit 7
fi;

# mkdir -p /usr/bin/
echo '#!/bin/sh' > /usr/bin/caddy.entrypoint
echo "/usr/bin/caddy run --config /pokus/config/${POKUS_CADDYFILE} --adapter caddyfile" >> /usr/bin/caddy.entrypoint
chmod +x /usr/bin/caddy.entrypoint

echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [Check - POKUS_CADDYFILE=[${POKUS_CADDYFILE}]]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
# echo "#  [netstat -tulpn]"
# echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

# netstat -tulpn
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [Check - /pokus/run/]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [Content of - /pokus/]"
ls -alh /pokus/
echo "#  [Content of - /pokus/run/]"
ls -alh /pokus/run/
echo "#  [Content of - /pokus/run/tls/]"
ls -alh /pokus/run/tls/
echo ''
echo ''
echo ''

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
if [ -f /data/caddy/pki/authorities/local/root.crt ]; then
  rm /data/caddy/pki/authorities/local/root.crt
fi;
mkdir -p /data/caddy/pki/authorities/local/
cp /pokus/tls/rootca/ca-cert.pem /data/caddy/pki/authorities/local/root.crt
cp /pokus/tls/rootca/ca-key.pem /data/caddy/pki/authorities/local/root.key

echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# >>>>++++++++++++++++++++++++++++++ #"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [Check - /data/caddy/pki/authorities/local/root.crt]"
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo "#  [Content of - /data/]"
ls -alh /data/ || true
echo "#  [Content of - /data/caddy/]"
ls -alh /data/caddy/ || true
echo "#  [Content of - /data/caddy/pki/]"
ls -alh /data/caddy/pki/ || true
echo "#  [Content of - /data/caddy/pki/authorities/]"
ls -alh /data/caddy/pki/authorities/ || true
echo "#  [Content of - /data/caddy/pki/authorities/local/]"
ls -alh /data/caddy/pki/authorities/local/ || true
echo "#  [Existence of - /data/caddy/pki/authorities/local/root.crt]"
ls -alh /data/caddy/pki/authorities/local/root.crt || true
echo "#  [Existence of - /data/caddy/pki/authorities/local/root.key]"
ls -alh /data/caddy/pki/authorities/local/root.key || true
echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
echo ''
echo ''
echo ''


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

        # gitea admin create-user --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email your@email.org --must-change-password=false && uploadConfigurationToCaddy
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "  INITIAL CADDY CONFIGURATION <<<<<< "
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
        # this command cannot be executed as long as the gitea install webui button is pressed...
        # gitea admin user create --admin --username $POKUS_ADMIN_USER --password $POKUS_ADMIN_PASSWORD --email pokus@pokus-io.org --access-token pokusdrone | tee ./gitea.cli.stdout
        # uploadConfigurationToCaddy
        uploadConfigurationToCaddyNEUTREULIZED
        echo "# -------------------------------------------------------------------------------- #"
        # echo "# ---   [LOOP TO DETECT CADDY STARTED] - CCCC=[${CCCC}]  "
        echo "# -------------------------------------------------------------------------------- #"
      	echo "# >>>>++++++++++++++++++++++++++++++ #"
        exit 0
    elif [ $ATTEMPT = $MAX_ATTEMPT ]; then
        exit 1
    fi;
done & /usr/bin/caddy.entrypoint
