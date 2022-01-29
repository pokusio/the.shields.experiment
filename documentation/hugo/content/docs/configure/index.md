---
title: 'Configuration'
date: 2019-02-11T19:30:08+10:00
draft: false
weight: 4
summary: Shields.io Configuration via `config/pokus.yml`.
---

## Finding the path

I pulled the docker image and ran shell interactively into it :

```bash
docker run -itd --name myshields --entrypoint /bin/sh shieldsio/shields:next
docker exec -it myshields sh -c "ls -alh && pwd"
```

* then I could see :

```bash
/usr/src/app # ls -alh ./**/*.yml
-rw-r--r--    1 root     root        3.0K Jan 29 05:47 ./config/custom-environment-variables.yml
-rw-r--r--    1 root     root         787 Jan 29 05:47 ./config/default.yml
-rw-r--r--    1 root     root         126 Jan 29 05:47 ./config/development.yml
-rw-r--r--    1 root     root         393 Jan 29 05:47 ./config/local-shields-io-production.template.yml
-rw-r--r--    1 root     root         482 Jan 29 05:47 ./config/local.template.yml
-rw-r--r--    1 root     root          39 Jan 29 05:47 ./config/production.yml
-rw-r--r--    1 root     root         383 Jan 29 05:47 ./config/shields-io-production.yml
-rw-r--r--    1 root     root         177 Jan 29 05:47 ./config/test.yml
-rw-r--r--    1 root     root      374.4K Jan 29 05:49 ./frontend/service-definitions.yml
/usr/src/app #
```

* Some of the example config files provided, are interesting:
  * `./config/custom-environment-variables.yml`
  * `./config/local.template.yml`
  * `./config/production.yml`
  * `./config/shields-io-production.yml`
  * `./frontend/service-definitions.yml`

* and i kept it all :

```bash
mkdir -p ./config/shields-snippets/frontend
docker cp jbl:/usr/src/app/config/custom-environment-variables.yml ./config/shields-snippets/
docker cp jbl:/usr/src/app/config/local.template.yml ./config/shields-snippets/
docker cp jbl:/usr/src/app/config/production.yml ./config/shields-snippets/
docker cp jbl:/usr/src/app/config/shields-io-production.yml ./config/shields-snippets/
docker cp jbl:/usr/src/app/frontend/service-definitions.yml ./config/shields-snippets/frontend
```

### The chosen Configuration

I finally took the below configuration, inspired by `./config/shields-snippets/production.yml`

```Yaml
public:
  metrics:
    prometheus:
      enabled: true
    influx:
      enabled: true
      # url: https://metrics.shields.io/telegraf
      url: https://metrics.pok-us.io/telegraf
      instanceIdFrom: env-var
      # instanceIdEnvVarName: HEROKU_DYNO_ID
      instanceIdEnvVarName: POKUS_DYNO_ID
      envLabel: shields-production

  ssl:
    isSecure: true

  cors:
    allowedOrigin: ['*']
    # allowedOrigin: ['http://shields.io', 'https://shields.io']

  # -> The raster service : when there is one, and it is independent (not insame container, not in same k8s deployment)
  rasterUrl: 'https://raster.pok-us.io'
  services:
    drone:
      # authorizedOrigins: ['https://drone.example.com']
      authorizedOrigins: ['*']

private:
  drone_token: 'value of the drone token here'

```


Note that [in `Dockerfile`](https://github.com/badges/shields/blob/bc5028fdcb7d292660d6932cafaa839aa05dced6/Dockerfile#L33), the startup command is `CMD node server`
