ARG GITEA_FROM="gitea/gitea:1.15.4"
# ARG GITEA_FROM="gitea/gitea:1.15.4-rootless"
# FROM gitea/gitea:1.12.5
FROM $GITEA_FROM

RUN apk update && apk add curl wget jq net-tools

ARG GITEA_CUSTOM=$GITEA_CUSTOM


# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# --- GITEA DATABASE USER FOR GITEA - POKUS

ARG POKUS_ADMIN_USER=$POKUS_ADMIN_USER
ENV POKUS_ADMIN_USER=$POKUS_ADMIN_USER
ARG POKUS_ADMIN_PASSWORD=POKUS
ENV POKUS_ADMIN_PASSWORD=$POKUS_ADMIN_PASSWORD



# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# --- POKUS NON ROOT USER

ARG POKUS_USER=$POKUS_USER
ARG POKUS_USER_UID=$POKUS_USER_UID
ARG POKUS_USER_GRPNAME=$POKUS_USER_GRPNAME
ARG POKUS_USER_GID=$POKUS_USER_GID


ENV POKUS_USER=$POKUS_USER
ENV POKUS_USER_UID=$POKUS_USER_UID
ENV POKUS_USER_GRPNAME=$POKUS_USER_GRPNAME
ENV POKUS_USER_GID=$POKUS_USER_GID


LABEL oci.image.pokus.user.name=$POKUS_USER
LABEL oci.image.pokus.user.group=$POKUS_USER_GID
LABEL oci.image.pokus.user.uid=$POKUS_USER_UID
LABEL oci.image.pokus.user.gid=$POKUS_USER_GID


# RUN groupadd -g $POKUS_USER_GID $POKUS_USER_GID
# RUN useradd -g $POKUS_USER_GID -u $POKUS_USER_UID -m $POKUS_USER

# with alpine : [addgroup [-g GID] [-S] [USER] GROUP]
RUN addgroup -g $POKUS_USER_GID GROUP $POKUS_USER_GRPNAME
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/$POKUS_USER" \
    --ingroup "$POKUS_USER_GRPNAME" \
    --no-create-home \
    --uid "$POKUS_USER_UID" \
    "$POKUS_USER"

RUN ls -allh /home/$POKUS_USER

# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# ====================================================================== #
# ====================================================================== #



ARG GITEA_SHARED_SECRETS_HOME="/pokus/.shared.secrets"
ENV GITEA_SHARED_SECRETS_HOME=$GITEA_SHARED_SECRETS_HOME

RUN mkdir -p $GITEA_SHARED_SECRETS_HOME

# ---
# Add a custom gitea theme based on matrix :) :
# https://github.com/TylerByte666/gitea-matrix-template
# awesome, to setup with docker build ?
# --- https://docs.gitea.io/en-us/customizing-gitea/
# --- https://github.com/TylerByte666/gitea-matrix-template
# ARG GITEA_CUSTOM_FILES_ROOT_PATH="/data/gitea"
ARG GITEA_CUSTOM_FILES_ROOT_PATH="/donnees/gitea"
RUN mkdir -p $GITEA_CUSTOM_FILES_ROOT_PATH/
ARG GITEA_UI_THEME_GIT_SSH_URI="https://github.com/TylerByte666/gitea-matrix-template"
# ARG GITEA_UI_THEME_GIT_SSH_URI="git@github.com:pokusio/gitea-matrix-template.git" # private backup of [https://github.com/TylerByte666/gitea-matrix-template]
RUN git clone ${GITEA_UI_THEME_GIT_SSH_URI} ${GITEA_CUSTOM_FILES_ROOT_PATH}
RUN mkdir -p ${GITEA_CUSTOM_FILES_ROOT_PATH}/templates && mkdir -p ${GITEA_CUSTOM_FILES_ROOT_PATH}/public/css
RUN cd ${GITEA_CUSTOM_FILES_ROOT_PATH} && git checkout release/v1.12.x

RUN mkdir -p $GITEA_CUSTOM_FILES_ROOT_PATH/conf/
RUN mkdir -p $GITEA_CUSTOM_FILES_ROOT_PATH/conf/ && ls -alh $GITEA_CUSTOM_FILES_ROOT_PATH/conf/
# RUN mkdir -p $GITEA_CUSTOM_FILES_ROOT_PATH/conf/ && echo '' >> ${GITEA_CUSTOM_FILES_ROOT_PATH}/conf/app.ini
# RUN mkdir -p $GITEA_CUSTOM_FILES_ROOT_PATH/conf/ && echo "[ui]" >> ${GITEA_CUSTOM_FILES_ROOT_PATH}/conf/app.ini
# RUN mkdir -p $GITEA_CUSTOM_FILES_ROOT_PATH/conf/ && echo "THEMES = gitea,arc-green,matrix" >> ${GITEA_CUSTOM_FILES_ROOT_PATH}/conf/app.ini
# RUN mkdir -p $GITEA_CUSTOM_FILES_ROOT_PATH/conf/ && echo "DEFAULT_THEME = matrix" >> ${GITEA_CUSTOM_FILES_ROOT_PATH}/conf/app.ini

RUN mkdir -p /pokus/run
WORKDIR /pokus/run
COPY start.sh .
RUN chmod a+x /pokus/run/start.sh

RUN mkdir -p $GITEA_SHARED_SECRETS_HOME
RUN mkdir -p $GITEA_SHARED_SECRETS_HOME && chown -R $POKUS_USER_UID:$POKUS_USER_GID $GITEA_SHARED_SECRETS_HOME
# --
# workaround old known issue of docker for
# non-root users, see : https://github.com/moby/moby/issues/2259#issuecomment-26564115
# RUN chown -R $POKUS_USER_UID:$POKUS_USER_GID /pokus
RUN chown -R $POKUS_USER:$POKUS_USER_GID /pokus
RUN chown -R $POKUS_USER:$POKUS_USER_GID $GITEA_CUSTOM_FILES_ROOT_PATH/
RUN mkdir -p /data && chown -R $POKUS_USER:$POKUS_USER_GID /data

WORKDIR /pokus/run
# USER root
USER $POKUS_USER


ENTRYPOINT ["/pokus/run/start.sh"]
