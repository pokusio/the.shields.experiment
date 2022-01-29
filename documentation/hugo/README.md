# The Shields Experiment's Hugo


This is the hugo website used to take notes during the work, and deliver the final result you are reading now.


<!--


One day, i learned how quickly you can set up a visitor counter using `visitor-badge.glitch.me`.

That Day, I realized how beautifully powerful the badge pattern can be: try implement a visitor counter yourself, from scratch, that can count visits with a different counter for every page...

All in all, this work is about designing an architecture for a static website :
* the static website is managed with one of the following CMS :
  * `hugo`
  * `Gatsby`
  * `Directus`

## Architecture

![Architecture big pic](./documentation/images/architecture/architecture-all.drawio.png)

 -->



## How to build and run locally

### B.O.M.

* [https://gohugo.io](https://gohugo.io/getting-started/quick-start/#step-1-install-hugo)
* [https://npmjs.org/](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
* https://go.dev/doc/install
*


* On MacOS X and GNU Linux :

```bash
bash-3.2$ node -v
v14.15.0
bash-3.2$ npm --version
6.14.8
bash-3.2$ export PATH=$PATH:/usr/local/go/bin
bash-3.2$ go version
go version go1.16.3 darwin/amd64
bash-3.2$ hugo version
Hugo Static Site Generator v0.78.2-959724F0 darwin/amd64 BuildDate: 2020-11-13T10:07:09Z
bash-3.2$ docker version
Client:
Cloud integration: 1.0.17
Version:           20.10.7
API version:       1.41
Go version:        go1.16.4
Git commit:        f0df350
Built:             Wed Jun  2 11:56:22 2021
OS/Arch:           darwin/amd64
Context:           default
Experimental:      true

Server: Docker Engine - Community
Engine:
 Version:          20.10.7
 API version:      1.41 (minimum version 1.12)
 Go version:       go1.13.15
 Git commit:       b0f5bc3
 Built:            Wed Jun  2 11:54:58 2021
 OS/Arch:          linux/amd64
 Experimental:     false
containerd:
 Version:          1.4.6
 GitCommit:        d71fcd7d8303cbf684402823e425e9dd2e99285d
runc:
 Version:          1.0.0-rc95
 GitCommit:        b9ee9c6314599f1b4a7f497e1f1f856fe433d3b7
docker-init:
 Version:          0.19.0
 GitCommit:        de40ad0
bash-3.2$ docker-compose version
Docker Compose version 2.2.3
bash-3.2$ git version
git version 2.24.3 (Apple Git-128)
bash-3.2$ git flow version
1.12.3 (AVH Edition)
```

### Build n Run Locally

* Now start the hugo server in watch mode :

```bash
export DESIRED_VERSION=0.0.0
cd ~/pokus.shields.work
git clone git@github.com:pokusio/the.shields.experiment.git ~/pokus.shields.work

git checkout ${DESIRED_VERSION}

npm i
# npm run spawn
# and then run :

export PATH=$PATH:/usr/local/go/bin && go version
hugo serve -b http://127.0.0.1:5454 -p 5454 --bind 127.0.0.1 -w

```


* Then start the hugo server in watch mode :

```bash
export DESIRED_VERSION=0.0.0
git clone git@github.com:pokusio/the.shields.experiment.git ~/pokus.shields.work
cd ~/pokus.shields.work

git checkout ${DESIRED_VERSION}

npm i
# npm run spawn
# and then run :

export PATH=$PATH:/usr/local/go/bin && go version
hugo serve -b http://127.0.0.1:5454 -p 5454 --bind 127.0.0.1 -w

```

## How to re-generate this project

To see how this website looked when it started, and was automatically generated :

* Execute :

```bash
export DESIRED_VERSION=master
git clone git@github.com:pokusio/the.shields.experiment.git ~/pokus.shields.work
cd ~/pokus.shields.work
git checkout ${DESIRED_VERSION}

npm i
npm run clean && npm run spawn
```

* Then run locally your new website :

```bash
export PATH=$PATH:/usr/local/go/bin
hugo serve -b http://127.0.0.1:5445 -p 5445 --bind 127.0.0.1 -w
```


## How to release

* Release :

```bash
git clone git@github.com:pokusio/the.shields.experiment.git ~/pokus.shields.release.work
cd ~/pokus.shields.release.work
git checkout master
git flow init --defaults

export RELEASE_VERSION=0.0.4
export DEPLOYMENT_DOMAIN=docs.shields-pok-us.io
export DEPLOYMENT_BASE_URL=https://${DEPLOYMENT_DOMAIN}
export DEPLOYMENT_BASE_URL=https://pokusio.github.io/the.shields.experiment/

git flow release start ${RELEASE_VERSION}

npm i

if [ -d ./docs ]; then
 rm -fr ./docs
fi;

if [ -d ./public ]; then
 rm -fr ./public
fi;

mkdir -p  ./docs
mkdir -p  ./public

export PATH=$PATH:/usr/local/go/bin
hugo -b ${DEPLOYMENT_BASE_URL}

cp -fr ./public/* ./docs/

echo "${DEPLOYMENT_DOMAIN}" > CNAME
echo "${DEPLOYMENT_DOMAIN}" > ./docs/CNAME

git add -A && git commit -m "[${RELEASE_VERSION}] - release and deployment" && git push -u origin HEAD

# git flow release finish ${RELEASE_VERSION} && git push -u origin --all  && git push -u origin --tags
git flow release finish -s ${RELEASE_VERSION} && git push -u origin --all  && git push -u origin --tags

```




## surge


```bash

export DEPLOYMENT_DOMAIN=docs.shields-pok-us.io
export DEPLOYMENT_BASE_URL=https://${DEPLOYMENT_DOMAIN}
export DEPLOYMENT_BASE_URL=https://pokusio.github.io/the.shields.experiment/

if [ -d ./docs ]; then
 rm -fr ./docs
fi;

if [ -d ./public ]; then
 rm -fr ./public
fi;

mkdir -p  ./docs
mkdir -p  ./public

export PATH=$PATH:/usr/local/go/bin
hugo -b ${DEPLOYMENT_BASE_URL}

cp -fr ./public/* ./docs/

surge ./public "${DEPLOYMENT_DOMAIN}"

```
