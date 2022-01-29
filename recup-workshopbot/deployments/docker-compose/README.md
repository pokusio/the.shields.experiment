# How to use


* Startup the stack a first time, by running :

```bash
export INSTALL_OPS_HOME=$(mktemp -d -t "pokus_install_ops-XXXXXXXXXX")
git clone git@github.com:pokusio/hubot-workshop.git ${INSTALL_OPS_HOME}
cd ${INSTALL_OPS_HOME}
git checkout develop
chmod +x ./**/**/*.sh
cd deployments/docker-compose/
./launch.sh

```



* Then, modify your `/etc/hosts`, so that the ip address of the machine where you install drone/gitea, is matched to the 2 domain names drone.pok-us.io gitea.pok-us.io

```bash
cat << EOF > ./etc.hosts.addon

# --- Pokus
192.168.1.101 chat.pok-us.io
192.168.1.101 drone.pok-us.io
192.168.1.101 gitea.pok-us.io
192.168.1.101 pokusbot.pok-us.io
192.168.1.101 vault.pok-us.io
192.168.1.101 minio.pok-us.io
192.168.1.101 n8n.pok-us.io
192.168.1.101 appsmith.pok-us.io
EOF

cat ./etc.hosts.addon | sudo tee -a /etc/hosts
```

* Now, browse to https://gitea.pok-us.io/ , and run the following operations :
  * `AUTOMATED - ` You first are directed to the install web page of gitea, and you will leave there all default, and just click the "Install" Button at bottom of page.
  * `AUTOMATED - ` create your first user, and create an **OAuth** app for drone, with redirect URI set to `https://drone.pok-us.io/login`: once the **OAuth** app is created, you get client id and client secret, which you will need to give to drone, **Nota Bene:** the `http://drone.pok-us.io/login` URL , because this is OAuth, will be used to lauch HTTP queries from your browser, so this will be _outside_ networking (outside docker). Indeed the Caddy Reverse Proxy will be first hit, and then redirected to the drone_server on port `443`, to proceed with the auth flow.
  <!-- * edit the `reboot-drone.sh` , and set the `DRONE_GITEA_CLIENT_ID` and the  `DRONE_GITEA_CLIENT_SECRET` to the value of the client Id and Client Secret of the **OAuth** App you just created in gitea,
  * then restart the drone by executing `bash reboot-drone.sh`, and browse to http://drone.pok-us.io:3001/ , the **OAuth** process to login for the first time into drone will happen, that URL could be used to have a welcome page in a web portal, and a "login with github' page just like for Circle CI. -->

You have now access to the Web Ui of Drone, at https://drone.pok-us.io/

#### Trigger a first drone circle ci pipeline

* Add an SSH Key to your gitea user, create an empty git repo
* Go to the rone Web UI at https://drone.pok-us.io/ , and :
  * click on the "`SYNC`" button (refreshes the list of git repos from your gitea user)
  * click on the "`Activate`" button to activate the pipeline for your new repo
* Git clone that empty repo using SSH, and run :

```bash
export POKUS_GITEA_SSH_PORT=2224
# cat ~/.ssh/id_rsa.pub
# Then add that SSH Key as SSH Key for your Gitea User, with Gitea Web UI
git clone ssh://git@gitea.pok-us.io:${POKUS_GITEA_SSH_PORT}/pokus/jbltest.git
cd jbltest/
touch README.md
git add -A && git commit -m "initial commit"
# sudo apt-get install -y  git-flow
git flow init --defaults && git push --defaults
git flow feature start add-drone-pipeline-def
git branch -a

cat << EOF > ./.drone.yml
kind: pipeline
type: docker
name: hello-world

trigger:
  branch:
    - master
    - feature/*
  event:
    - push

steps:
  - name: say-hello
    image: busybox
    commands:
      - echo hello-world

EOF

git add --all && git commit -m "add drone yaml pipeline def" && git push -u origin --all

```

Now go back to the Drone Web UI at http://drone.pok-us.io/, you must see your pipeline running

See also https://github.com/pokusio/simple-drone/issues/1


#### Re-launch it all fresh (without respawning or restarting VM)

If you want to destroy it all, and re-launch it all fresh new :

```bash
# --- You must be in the folder where the docker-compose.yml is
export INSTALL_OPS_HOME=$(pwd)/../../
docker-compose down --rmi all && docker system prune -f --all && docker system prune -f --volumes && cd && sudo rm -fr ${INSTALL_OPS_HOME}

git clone git@github.com:pokusio/hubot-workshop.git ${INSTALL_OPS_HOME}
cd ${INSTALL_OPS_HOME}
git checkout develop
chmod +x ./**/**/*.sh
cd deployments/docker-compose/
./launch.sh

```

### Re launch after filling in Gitea OAuth client id and client secret (Test mode simplified drone server)

```bash
export DRONE_GITEA_CLIENT_ID=<your DRONE_GITEA_CLIENT_ID>
export DRONE_GITEA_CLIENT_SECRET=<your DRONE_GITEA_CLIENT_SECRET>

sed -i "s#DRONE_GITEA_CLIENT_ID_PLACEHOLDER#${DRONE_GITEA_CLIENT_ID}#g" ./.env
sed -i "s#DRONE_GITEA_CLIENT_SECRET_PLACEHOLDER#${DRONE_GITEA_CLIENT_SECRET}#g" ./.env

source ./.env && docker-compose up --force-recreate -d drone_server && docker-compose logs -f drone_server

```
