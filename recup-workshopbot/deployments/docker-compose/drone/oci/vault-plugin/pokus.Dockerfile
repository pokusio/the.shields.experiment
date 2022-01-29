# note: never use the :latest tag in a production site
ARG DRONE_VAULT_CONTAINER_TAG=$DRONE_VAULT_CONTAINER_TAG
ARG DRONE_VAULT_FROM=drone/vault:$DRONE_VAULT_CONTAINER_TAG
ARG DRONE_VAULT_FROM=drone/vault:$DRONE_VAULT_CONTAINER_TAG
FROM $DRONE_VAULT_FROM
# drone/drone:2.4.0

ARG POKUS_DRONE_VAULT_TOKEN_SECRET_PATH=$POKUS_DRONE_VAULT_TOKEN_SECRET_PATH
ENV POKUS_DRONE_VAULT_TOKEN_SECRET_PATH=$POKUS_DRONE_VAULT_TOKEN_SECRET_PATH
ARG GITEA_SHARED_SECRETS_HOME=/pokus/.shared.secrets
ENV GITEA_SHARED_SECRETS_HOME=$GITEA_SHARED_SECRETS_HOME
RUN mkdir -p $GITEA_SHARED_SECRETS_HOME

RUN apk update && apk add bash jq vim curl wget net-tools


RUN mkdir -p /pokus/run

WORKDIR /pokus/run


COPY start.sh .
RUN chmod a+x ./start.sh
ENTRYPOINT ["/pokus/run/start.sh"]
# CMD ["/pokus/run/start.sh"]
# ENTRYPOINT ["/bin/drone-server"]
