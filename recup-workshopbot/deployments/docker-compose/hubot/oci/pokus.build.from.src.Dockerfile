# FROM node:4.8.3
# FROM node:14
ARG NODE_CONTAINER_TAG=$NODE_CONTAINER_TAG
ARG POKUS_FROM=node:$NODE_CONTAINER_TAG
FROM $POKUS_FROM
LABEL oci.image.pokus.image.authors="<Jean-Baptiste Lasselle> jean.baptiste.lasselle@gmail.com"

ARG COFFESCRIPT_VERSION=$COFFESCRIPT_VERSION
ARG YO_VERSION=$YO_VERSION
ARG YO_GENERATOR_VERSION=$YO_GENERATOR_VERSION

# RUN npm install -g coffee-script yo generator-hubot  &&	useradd hubot -m
RUN npm install -g coffee-script@$COFFESCRIPT_VERSION yo@$YO_VERSION generator-hubot@$YO_GENERATOR_VERSION  &&	useradd hubot -m

# --- # --- # --- # --- #
# --- POKUS ANALYSIS:
# --- + This image is very simple in one idea: in a nodejs image, generate a hubot project with the rocketchat hubot adapter into ${POKUS_PROJECT_FOLDER}, then add the source code of your hubot into the ${POKUS_PROJECT_FOLDER}/node_modules folder , run npm install, and there you go
# --- + This image is very bad : it shoudl be at least a multi stage build with a release last stage
# --- + This image is very bad : it is base on a very old nodejs versin, cetainly way out of support
# --- + This image has very old versions of hubot sdk etc. : https://github.com/RocketChat/hubot-rocketchat/issues/286
# --- + Conclusion 1 : this image was quickly designed to show deelopers how to depoy their hubots
# --- +
# --- # --- # --- # --- #

# --- # --- # --- # --- #
# --- POKUS DEVOPS ADDON BEGINNING
# --- # --- # --- # --- #
RUN apt-get update -y && apt-get install -y git git-flow curl wget tree
# I do not understand how those env var can be passed to hubot runtime without being declared in Dokerfile...
ENV ROCKETCHAT_URL=$ROCKETCHAT_URL
ENV ROCKETCHAT_ROOM=$ROCKETCHAT_ROOM
ENV ROCKETCHAT_USER=$ROCKETCHAT_USER
ENV ROCKETCHAT_PASSWORD=$ROCKETCHAT_PASSWORD
ENV ROCKETCHAT_AUTH=$ROCKETCHAT_AUTH
ENV BOT_NAME=$BOT_NAME
ENV HUBOT_NAME=$HUBOT_NAME
ENV HUBOT_LOG_LEVEL=$HUBOT_LOG_LEVEL
ENV RESPOND_TO_DM=$RESPOND_TO_DM
ENV EXTERNAL_SCRIPTS=$EXTERNAL_SCRIPTS
# --- # --- # --- # --- #
# --- POKUS DEVOPS ADDON END
# --- # --- # --- # --- #
USER hubot

WORKDIR /home/hubot

ENV BOT_NAME "hokusbot"
ENV BOT_OWNER "No owner specified"
ENV BOT_DESC "Pokus Hubot with rocketbot adapter"

ENV EXTERNAL_SCRIPTS=hubot-diagnostics,hubot-help,hubot-google-images,hubot-google-translate,hubot-pugme,hubot-maps,hubot-rules,hubot-shipit

RUN yo hubot --owner="$BOT_OWNER" --name="$BOT_NAME" --description="$BOT_DESC" --defaults && \
	sed -i /heroku/d ./external-scripts.json && \
	sed -i /redis-brain/d ./external-scripts.json && \
	npm install hubot-scripts

ADD . /home/hubot/node_modules/hubot-rocketchat

# hack added to get around owner issue: https://github.com/docker/docker/issues/6119
USER root
RUN chown hubot:hubot -R /home/hubot/node_modules/hubot-rocketchat
USER hubot

RUN cd /home/hubot/node_modules/hubot-rocketchat && \
	npm install && \
	coffee -c /home/hubot/node_modules/hubot-rocketchat/src/*.coffee && \
	cd /home/hubot

CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
	npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && \
	bin/hubot -n $BOT_NAME -a rocketchat
