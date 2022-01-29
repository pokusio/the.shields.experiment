---
title: 'Asciinema'
date: 2022-01-29T19:27:37+10:00
weight: 7
---

_The best cinema, for the best study_

### Install `asciinema`

see https://asciinema.org/docs/installation

### Record

* execute the following command :

```bash

asciinema rec -t "openfaas demo" openfaas.json

```

* type exit or `Ctrl + D` to stop the recording.

### Convert from json to gif.

* See npm package https://github.com/asciinema/asciicast2gif and `docker pull asciinema/asciicast2gif`

* converting the said images :

```bash
docker pull asciinema/asciicast2gif
# docker run --rm -v $PWD:/data asciinema/asciicast2gif [options and arguments...]


docker run --rm -v $PWD:/data asciinema/asciicast2gif -s 2 -t solarized-dark openfaas.json openfaas.gif

```

### Add to hugo project


And use the `asciinema` hugo `shortcode` and `partial` :


##### The shortcode

```md
{{< asciinema movie_uri="/images/pokus/openfaas.gif" >}}
```


##### The partial

```Html
$movie_uri := "/images/pokus/openfaas.gif"
<!-- And below in partial, sinc ethe context is passed to partial, the "$movie_uri" variable will be available. -->
{{ partial "asciinema.html" . }}
```
