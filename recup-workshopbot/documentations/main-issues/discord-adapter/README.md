I ran a few tests, and I get an error using the most popular hubot discord adapter :


```bash
$ bin/hubot --name bernardbot
npm WARN EBADENGINE Unsupported engine {
npm WARN EBADENGINE   package: 'jblbot@0.0.0',
npm WARN EBADENGINE   required: { node: '0.10.x' },
npm WARN EBADENGINE   current: { node: 'v14.4.0', npm: '7.20.5' }
npm WARN EBADENGINE }

up to date, audited 179 packages in 1s

5 packages are looking for funding
  run `npm fund` for details

2 low severity vulnerabilities

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
bernardbot> [Mon Oct 11 2021 04:48:55 GMT+0200 (Central European Summer Time)] WARNING Expected /home/jibl/testhubot/myhubot/scripts/discord to assign a function to module.exports, got object
[Mon Oct 11 2021 04:48:55 GMT+0200 (Central European Summer Time)] ERROR Unable to load /home/jibl/testhubot/myhubot/scripts/reaction_message: TypeError: Cannot read property 'room' of undefined
  at new Message (/home/jibl/testhubot/myhubot/node_modules/hubot/src/message.js:10:27)
  at CoffeeScriptCompatibleClass (/home/jibl/testhubot/myhubot/node_modules/hubot/index.js:21:22)
  at ReactionMessage (/home/jibl/testhubot/myhubot/scripts/reaction_message.coffee:14:8, <js>:18:45)
  at Robot.loadFile (/home/jibl/testhubot/myhubot/node_modules/hubot/src/robot.js:363:9)
  at /home/jibl/testhubot/myhubot/node_modules/hubot/src/robot.js:383:52
  at Array.map (<anonymous>:null:null)
  at Robot.load (/home/jibl/testhubot/myhubot/node_modules/hubot/src/robot.js:383:35)
  at Shell.loadScripts (/home/jibl/testhubot/myhubot/node_modules/hubot/bin/hubot.js:115:9)
  at Object.onceWrapper (events.js:421:28)
  at Shell.emit (events.js:315:20)
  at /home/jibl/testhubot/myhubot/node_modules/hubot/src/adapters/shell.js:47:19
  at Interface.<anonymous> (/home/jibl/testhubot/myhubot/node_modules/hubot/src/adapters/shell.js:136:24)
  at Interface.emit (events.js:327:22)
  at Interface.close (readline.js:424:8)
  at ReadStream.onend (readline.js:202:10)
  at ReadStream.emit (events.js:327:22)
  at endReadableNT (_stream_readable.js:1224:12)
  at processTicksAndRejections (internal/process/task_queues.js:84:21)


```

You can reproduce this error with release version `0.0.1` like this :

```bash
export REPO_SSH_URI="git@github.com:pokusio/hubot-workshop.git"
export WORK_HOME="~/testmybot-$RANDOM"
if [ -d ${WORK_HOME} ]; then
  rm -fr ${WORK_HOME}
fi;
mkdir -p ${WORK_HOME}
git clone ${REPO_SSH_URI} ${WORK_HOME}
cd ${WORK_HOME}
git checkout 0.0.1


npm i -s hubot-discord
sudo npm install -g hubot-discord
# adding the two discord adapter coffee scripts
cp scriptsfordiscord/discord.coffee scripts/
cp scriptsfordiscord/reaction_message.coffee scripts/

# -- and now starting bot as usual

export HUBOT_DISCORD_TOKEN="ODk2OTQwMjU3Mjk4MjUxODE4.YWOatQ.1ojq1MIZ8bLstM2RVV_4c-RJDXk"
export HUBOT_MAX_MESSAGE_LENGTH="2000"
export HUBOT_HEROKU_KEEPALIVE_URL='nimportequoi://ahouaisdaccord.io'
bin/hubot --name bernardbot
# an hen execute comand :
bernardbot map me "2 avenue de 'lunion soviétque clermont ferrand"
@bernardbot open the pod bay doors
bernardbot deploy awesometreesio.io git@github.com:territoires-et-futurs/siteweb.git develop git@github.com:zhaohuabing/hugo-theme-cleanwhite.git master

```
