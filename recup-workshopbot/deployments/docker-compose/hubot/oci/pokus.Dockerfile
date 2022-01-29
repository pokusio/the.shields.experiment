FROM rocketchat/hubot-rocketchat:latest


# Blank space separated list of linux packages to install
# ARG POKUS_ADDITIONAL_LX_PACKAGES="git git-flow curl wget tree"
ARG POKUS_ADDITIONAL_LX_PACKAGES=""
# Blank space separated list of additional nodejs/npm packages to install
# ARG POKUS_ADDITIONAL_NPM_PACKAGES="shelljs"
ARG POKUS_ADDITIONAL_NPM_PACKAGES
ENV POKUS_ADDITIONAL_NPM_PACKAGES=$POKUS_ADDITIONAL_NPM_PACKAGES

ARG POKUS_GIT_SSH_CMD='ssh -vvvai /home/hubot/pokus/secrets/.ssh/id_rsa'
ENV POKUS_GIT_SSH_CMD=$POKUS_GIT_SSH_CMD





ARG VAULT_TOKEN=inyourdreams
ENV VAULT_TOKEN=$VAULT_TOKEN


ARG VAULT_ADDR=http://vault-server:8200
ENV VAULT_ADDR=$VAULT_ADDR


ARG HUBOT_STARTUP_ROOM=general
ENV HUBOT_STARTUP_ROOM=$HUBOT_STARTUP_ROOM

ARG HUBOT_STARTUP_MESSAGE='Hello World! This is Pokus!'
ENV HUBOT_STARTUP_MESSAGE=$HUBOT_STARTUP_MESSAGE

ARG GIT_USER_GPG_SIGNING_KEY
ENV GIT_USER_GPG_SIGNING_KEY=$GIT_USER_GPG_SIGNING_KEY
ARG GIT_USER_NAME
ENV GIT_USER_NAME=$GIT_USER_NAME
ARG GIT_USER_EMAIL
ENV GIT_USER_EMAIL=$GIT_USER_EMAIL

ARG GITEA_SHARED_SECRETS_HOME
ENV GITEA_SHARED_SECRETS_HOME=$GITEA_SHARED_SECRETS_HOME
ARG POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH
ENV POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH=$POKUS_HUBOT_VAULT_TOKEN_SECRET_PATH

USER root
RUN mkdir -p /pokus/secrets/.ssh && mkdir -p /pokus/run/lib
ADD simple-start.sh /pokus/run
# /pokus/run/lib/ssh-git-config.sh
ADD ssh-git-config.sh /pokus/run/lib
# /pokus/run/lib/prepare-load-ssh-keys.sh
ADD prepare-load-ssh-keys.sh /pokus/run/lib
RUN chmod +x /pokus/run/simple-start.sh && chmod +x /pokus/run/lib/ssh-git-config.sh && chmod +x /pokus/run/lib/prepare-load-ssh-keys.sh
RUN chown -R hubot:hubot /pokus/
RUN apt-get update -y && apt-get install -y bash curl wget net-tools openssh-client $POKUS_ADDITIONAL_LX_PACKAGES

USER hubot

# CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
# 	npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && npm i -s $POKUS_ADDITIONAL_NPM_PACKAGES && \
# 	bin/hubot -n $BOT_NAME -a rocketchat
CMD ["/pokus/run/simple-start.sh"]
