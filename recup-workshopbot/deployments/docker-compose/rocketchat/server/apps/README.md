# Develop and Deploy your RocketChat Apps!

In the example below, I create a **RocketChat App** named `medor`, and I deploy i to my own rocketchaty server

Before executing the below shell commands, you must "Enable RocketChat Apps"
```bash
docker run -itd --restart always --name jblcli --add-host="chat.pok-us.io:192.168.1.101" node sh
# install utilities and RocketChat CLI 'rc-apps' into the docker container
docker exec -it jblcli sh -c "apt-get update -y && apt-get install -y curl vim iputils-ping && npm install -g @rocket.chat/apps-cli"
# generates a new RocketChat App Project, with all its source code etc... It's an npm project / typescript etc... (so gt commit and push)
docker exec -it jblcli sh -c "cd rapodi && rc-apps create --name medor --description 'jbl est le meilleur' --author 'jbl' --homepage https://github.com/jbl --support https://github.com/jbl"
docker exec -it jblcli sh -c "cd rapodi && cd medor && rc-apps package"
docker exec -it jblcli sh -c "cd rapodi && cd medor && rc-apps deploy -vvvv --url=https://chat.pok-us.io:443/ --username=pokus --password=pokus"
```
