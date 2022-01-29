# Using the Pokus Bot

* once you are logged in for the first time, the first thing you do is :
  * create a channel named `pokusroom` (choose any name for that new channel, any name but `general`, which is an already existing channel)
  * then :
    * in the channel send the message `@pokusbot pug me`, and enjoy the result :)
    * then send the exact message `pokusbot deploy awesometreesio.io git@github.com:territoires-et-futurs/siteweb.git develop git@github.com:zhaohuabing/hugo-theme-cleanwhite.git master`
    * send a direct message to the `pokusbot` user, exactly that message : `pug me`
* then in the channel send the message `@pokusbot pug me`, and enjoy the result :)


## Pokus! (Requirements)

The current docker image of `hubot-rocketchat`, has `1001` hard coded as the `hubot` linux user `uid` and `gid`.

That is why a linux user must be created on the docker host, with `1001` hard coded as the `hubot` linux user `uid` and `gid` :

* To create that user, execute the below commands on the `GNU/Linux Debian` Docker Host :

```bash
export POKUS_USER_GID=1001
export POKUS_USER_GRP=pokus
export POKUS_USER_UID=1001
export POKUS_USER=pokus

sudo groupadd -g $POKUS_USER_GID $POKUS_USER_GRP
sudo useradd -g $POKUS_USER_GID -u $POKUS_USER_UID -m $POKUS_USER

sudo usermod -aG docker $POKUS_USER
sudo usermod -aG sudo $POKUS_USER

echo -e 'pokpokpok\npokpokpok' | sudo passwd pokus

sudo mkdir -p /home/${POKUS_USER}/.ssh
sudo cp /home/jbl/.ssh/id_rsa /home/${POKUS_USER}/.ssh/id_rsa
sudo cp /home/jbl/.ssh/id_rsa.pub /home/${POKUS_USER}/.ssh/id_rsa.pub

sudo chown -R $POKUS_USER:$POKUS_USER_GRP /home/pokus
sudo -u $POKUS_USER chmod -R 700 /home/${POKUS_USER}/.ssh
sudo -u $POKUS_USER chmod 644 /home/${POKUS_USER}/.ssh/id_rsa.pub
sudo -u $POKUS_USER chmod 600 /home/${POKUS_USER}/.ssh/id_rsa

```


### Analysis of source code of hubot rocketchat adapter


Runtime Dependencies :
* in `package.json` are from back 3 yaers so year`2018` : so the idea is that for each dependency we are going to stick to the latest release of year 2018
* `asteroid` :
  * There is no more maintainers work on this one, their latest release is `v0.6.1` and dates back to 2015  https://github.com/RocketChat/asteroid/releases/tag/v0.6.1 . And there fore it was th latest commit on master which was used by rocketchat dev team
  *   * version orginally used in the `package.json` : `"asteroid": "https://github.com/RocketChat/asteroid.git",`
* `lru-cache` :
  * seems like it is https://github.com/isaacs/node-lru-cache
  * latest release in 2018 is version `4.1.5` https://github.com/isaacs/node-lru-cache/releases/tag/v4.1.5
  * version orginally used in the `package.json` : `"lru-cache": "~4.0.2"`
* `parent-require` :
  * seems like it is https://github.com/jaredhanson/node-parent-require
  * latest release in 2018 is version : `1.0.0` the only one release in this repo is https://github.com/jaredhanson/node-parent-require/releases/tag/v1.0.0
  * version orginally used in the `package.json` : `"parent-require": "^1.0.0",`
* `q` :
  * seems like it is https://github.com/kriskowal/q
  * latest release in 2018 is version : `1.5.1` , latest release dates back to `2017` https://github.com/kriskowal/q/releases/tag/v1.5.1
  * version orginally used in the `package.json` : `"q": "^1.5.0",`
* `shelljs` :
  * that dependency was not in the original rocketchat package.json , i added it in `October 2021` for capabilities of the bot in my coffeescripts.
  * seems like it is cccc
  * latest release in 2018 is version : `ccc`
  * version used in the `package.json` : `"shelljs": "^0.8.4"`


Develoment Dependencies :

* Those dependencies dthe rockketcaht team had the very, very bad dea of using their "latest" release not fixed verson, and I higly suspect my issues are because of that
* The `yo` package (what was the version 3 years ago ?) :
  * seems like it is https://github.com/yeoman/yo
  * latest release in `2018` is version : `2.0.5` https://github.com/yeoman/yo/releases/tag/v2.0.5
  * latest release in `2017` is version : `2.0.0` https://github.com/yeoman/yo/releases/tag/v2.0.0
  * version used in the `package.json` : `not there see dockerfile`

* `coffee-script`
  * seems like it is https://github.com/jashkenas/coffeescript/releases/tag/2.3.2
  * latest release in 2018 is version : `2.3.2`
  * version used in the `package.json` : `"coffee-script": "~1.12.6"`
  * note that version `1.12.6` of `coffee-script` is from May `2017` (confirms hubot rocketchat was devloped between `2017`/`2018`, based on `nodejs version 4`) https://github.com/jashkenas/coffeescript/releases/tag/1.12.6

* The `generator-hubot` `yo` generator
  * seems like it is https://github.com/hubotio/generator-hubot
  * latest release in 2018 is version : `1.1.0` https://github.com/hubotio/generator-hubot/releases/tag/v1.1.0
  * other previous versions from 2018 :
    * `1.0.0` : is from `2017`
    * `0.4.0` : is from `2016` (not worth trying earlier yet)
  * version used in the `package.json` : `not there see dockerfile`

  *


so i ended up :
* Run the container from dockerhub, and git commt and push the /home/hubot full folder,
* see https://github.com/pokusio/rocketchat-hubot-extract-from-container
