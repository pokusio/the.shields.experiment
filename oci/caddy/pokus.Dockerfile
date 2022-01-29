# note: never use the :latest tag in a production site
# https://hub.docker.com/_/caddy
# https://github.com/caddyserver/caddy-docker
ARG POKUS_CADDY_VERSION=$POKUS_CADDY_VERSION
ARG CADDY_FROM=caddy:$POKUS_CADDY_VERSION
FROM $CADDY_FROM


RUN apk update && apk add bash jq vim curl
# COPY Caddyfile /usr/bin/caddyfile

# COPY site /srv

RUN mkdir -p /pokus/run && mkdir -p /pokus/config && mkdir -p /pokus/tls/rootca
COPY Caddyfile /pokus/config/Caddyfile
COPY Caddyfile.lb /pokus/config/Caddyfile.lb
WORKDIR /pokus/run

ARG POKUS_CADDYFILE=Caddyfile.lb
ENV POKUS_CADDYFILE=$POKUS_CADDYFILE

RUN mkdir -p /usr/bin/
RUN echo '#!/bin/sh' > /usr/bin/caddy.entrypoint
RUN echo '/usr/bin/caddy run --config /pokus/config/Caddyfile --adapter caddyfile' >> /usr/bin/caddy.entrypoint
RUN chmod a+x /usr/bin/caddy.entrypoint
# CMD ["caddy", "run", "--config", "/usr/bin/caddyfile", "--adapter", "caddyfile"]


# https://caddyserver.com/docs/getting-started#your-first-config
COPY caddy.json .

COPY start.sh .
RUN chmod a+x ./start.sh
CMD ["/pokus/run/start.sh"]
