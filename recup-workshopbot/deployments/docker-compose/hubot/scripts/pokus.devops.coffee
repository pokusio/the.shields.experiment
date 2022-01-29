# Description
#   A Hubot script that greets us when this script loaded.
#
# Configuration:
#   HUBOT_STARTUP_ROOM
#   HUBOT_STARTUP_MESSAGE
#
# -
#
# Commands:
#   @pokusbot deploy <#{domainName}> <#{gitSshUri}> <#{gitVersion}> <#{hugoThemeSsh}> <#{hugoThemeVersion}>
# -
# WHERE :
# -
# #{domainName}
# #{gitSshUri}
# #{gitVersion}
# #{hugoThemeSsh}
# #{hugoThemeVersion}
#
# #>> Author:
#   Jean-Baptiste Lasselle <jean.baptiste.lasselle@gmail.com>
#
shell = require('shelljs');

vault = require('node-vault');

semver = require('semver');

fs = require('fs');

module.exports = (robot) ->
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- THIS IS EXECUTED AT POKUSBOT STARTUP, WHEN THIS COFFEESCRIPT SCRIPT IS LOADED, NOT EVERY TIME ROBOT HEARS OR RESPONDS
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-

  ROOM = process.env.HUBOT_STARTUP_ROOM ? 'pokusroom'
  MESSAGE = process.env.HUBOT_STARTUP_MESSAGE ? 'Hello, default world!'
  VAULT_TOKEN = process.env.VAULT_TOKEN ? 'inyourdreams;)'
  VAULT_ADDR = process.env.VAULT_ADDR ? 'http://vault_server:8200'

  console.log "VAULT_TOKEN : [#{VAULT_TOKEN}]"
  console.log "VAULT_ADDR : [#{VAULT_ADDR}]"
  console.log "HUBOT_STARTUP_ROOM : [#{HUBOT_STARTUP_ROOM}]"
  console.log "HUBOT_STARTUP_MESSAGE : [#{HUBOT_STARTUP_MESSAGE}]"

  # add support for HUBOT_STARTUP_ROOM to be of format #general for channel name or @somebody for username
  roomOrPerson = { "room": /^#(.*)/, "person": /^@(.*)/ }
  isRoom =  ROOM.match roomOrPerson.room
  isPerson =  ROOM.match roomOrPerson.person
  if isRoom then return robot.messageRoom isRoom[1], MESSAGE
  if isPerson then return robot.send {"room":isPerson[1]}, MESSAGE

  robot.messageRoom ROOM, MESSAGE

  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-

  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- AT POKUSBOT STARTUP: I load the SSH Key from Vault
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # //***
  # //* /pokus/run/lib/prepare-load-ssh-keys.sh creates 2 folders :
  # //*
  # //* - /home/hubot/pokus/secrets/.ssh
  # //* - /home/hubot/pokus/secrets/.gungpg
  # //*
  # //***/
  # //
  if shell.exec('/pokus/run/lib/prepare-load-ssh-keys.sh').code != 0
    # // Run external tool synchronously
    shell.echo('Error: executing the [/pokus/run/lib/prepare-load-ssh-keys.sh] shell script');
    shell.exit(1);
  else
    shell.echo('Executing the [/pokus/run/lib/prepare-load-ssh-keys.sh] shell script succeeded');

  console.log "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  console.log "# -- # --    Successfully Completed the [prepare-load-ssh-keys.sh]! "
  console.log "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

  # !---! # !---
  # // >>> // >>> //
  # // >>>>>>>>>>>> And here i retrieve the ssh key using node-vault:
  # // >>> // >>> //
  # We want Pub and Private SSH Keys to end up being used from [/home/hubot/pokus/secrets/.ssh]
  #    Public Key : [/home/hubot/pokus/secrets/.ssh/id_rsa.pub]"
  #    Private Key : [/home/hubot/pokus/secrets/.ssh/id_rsa]"
  # echo "   pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key"
  # echo "   pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key"
  # !---! # !---

  # !--- SSH PUB KEY FILE :
  #    Public Key : [/home/hubot/pokus/secrets/.ssh/id_rsa.pub]"
  # // $ vault read -field=value secret/ssh-keys/centos.pem > ~/.ssh/id_rsa-centos.pem
  # // $ chmod 600 ~/.ssh/id_rsa-centos.pem

  # # // vault.write('secret/hello', { value: 'world', lease: '1s' })
  # # //   .then( () => vault.read('secret/hello'))
  # # //   .then( () => vault.delete('secret/hello'))
  # # //   .catch(console.error);

  # !--- SSH PUBLIC KEY FILE :
  #    Public Key : [/home/hubot/pokus/secrets/.ssh/id_rsa.pub]"
  # // $ vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key > /home/hubot/pokus/secrets/.ssh/id_rsa.pub
  # // $ chmod 600 /home/hubot/pokus/secrets/.ssh/id_rsa.pub
  pokusPublicSSHKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot_ssh_pub_key')).catch(console.error);
  # !--- SSH PRIVATE KEY FILE :
  #    Private Key : [/home/hubot/pokus/secrets/.ssh/id_rsa]"
  # // $ vault read -field=value pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key > /home/hubot/pokus/secrets/.ssh/id_rsa
  # // $ chmod 644 /home/hubot/pokus/secrets/.ssh/id_rsa
  pokusPrivateSSHKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot_ssh_priv_key')).catch(console.error);



  pokusGpgPublicKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot.gpg.pub.key') # pokusbot.gpg.pub.key
  pokusGpgPrivateKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot.gpg.priv.key') # pokusbot.gpg.priv.key
  pokusGitUserName = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot_git_user_name') # git_user_name
  pokusGitUserEmail = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot_git_user_email') # git_user_email
  pokusGitUserGpgSingingKey = vault.read('pokus.hubot.secrets/dev_hubot/pokusbot_git_user_gpg_signing_key') # git_user_email




  # # echo $GIT_SSH_PUB_KEY > /home/hubot/pokus/secrets/.ssh/id_rsa.pub
  # # echo $GIT_SSH_PRIVATE_KEY > /home/hubot/pokus/secrets/.ssh/id_rsa

  # # echo $POKUSIO_GPG_PUB_KEY > /home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.pub.key
  # # echo $POKUSIO_GPG_PRV_KEY > /home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.priv.key
  # # echo $GIT_USER_NAME > /home/hubot/pokus/secrets/pokusbot_git_user_name
  # # echo $GIT_USER_EMAIL > /home/hubot/pokus/secrets/pokusbot_git_user_email
  # # echo $GIT_USER_GPG_SIGNING_KEY > /home/hubot/pokus/secrets/pokusbot_git_user_gpg_signing_key



  pokusPrivateSSHKeyPath = '/home/hubot/pokus/secrets/.ssh/id_rsa'
  pokusPublicSSHKeyPath = '/home/hubot/pokus/secrets/.ssh/id_rsa.pub'

  pokusGpgPublicKeyPath = '/home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.pub.key'
  pokusGpgPrivateKeyPath = '/home/hubot/pokus/secrets/.gungpg/pokusbot.gpg.priv.key'
  pokusGitUserNamePath = '/home/hubot/pokus/secrets/pokusbot_git_user_name'
  pokusGitUserEmailPath = '/home/hubot/pokus/secrets/pokusbot_git_user_email'
  pokusGitUserGpgSingingKeyPath = '/home/hubot/pokus/secrets/pokusbot_git_user_gpg_signing_key'




  # // --- // #
  try {
    fs.writeFileSync("#{pokusPublicSSHKeyPath}", pokusPublicSSHKey, {}); // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusPublicSSHKeyPath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusPublicSSHKeyPath}");
    console.error(err);
    throw err;
  }



  try {
    fs.writeFileSync("#{pokusPrivateSSHKeyPath}", pokusPrivateSSHKey, {}); // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusPrivateSSHKeyPath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusPrivateSSHKeyPath}");
    console.error(err);
    throw err;
  }

  # // --- CHIRURGIE
  # // --- CHIRURGIE
  # // --- CHIRURGIE

  try {
    fs.writeFileSync("#{pokusPrivateSSHKeyPath}", pokusGpgPublicKey, {}); // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusGpgPublicKeyPath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusGpgPublicKeyPath}");
    console.error(err);
    throw err;
  }

  try {
    fs.writeFileSync("#{pokusPrivateSSHKeyPath}", pokusGpgPrivateKey, {}); // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusGpgPrivateKeyPath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusGpgPrivateKeyPath}");
    console.error(err);
    throw err;
  }

  try {
    fs.writeFileSync("#{pokusPrivateSSHKeyPath}", pokusGitUserName, {}); // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusGitUserNamePath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusGitUserNamePath}");
    console.error(err);
    throw err;
  }

  try {
    fs.writeFileSync("#{pokusPrivateSSHKeyPath}", pokusPrivateSSHKey, {}); // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusPrivateSSHKeyPath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusPrivateSSHKeyPath}");
    console.error(err);
    throw err;
  }


  # // --- CHIRURGIE
  # // --- CHIRURGIE
  # // --- CHIRURGIE


  # // --- CHIRURGIE 2


  try {
    fs.writeFileSync("#{pokusGitUserNamePath}", pokusGitUserName, {}); # // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusGitUserNamePath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusGitUserNamePath}");
    console.error(err);
    throw err;
  }


  try {
    fs.writeFileSync("#{pokusGitUserEmailPath}", pokusGitUserEmail, {}); # // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusGitUserEmailPath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusGitUserEmailPath}");
    console.error(err);
    throw err;
  }

  try {
    fs.writeFileSync("#{pokusGitUserGpgSingingKeyPath}", pokusGitUserGpgSingingKey, {}); # // no options
    console.log("{[pokusbot]} - Successfully wrote to #{pokusGitUserGpgSingingKeyPath}");
  } catch(err) {
    # // An error occurred
    console.log("{[pokusbot]} - An Error occurred writing to #{pokusGitUserGpgSingingKeyPath}");
    console.error(err);
    throw err;
  }

  # // --- CHIRURGIE 2

  if !fs.existsSync(pokusPrivateSSHKeyPath)
    throw new Error("{[pokusbot]} - [#{pokusPrivateSSHKeyPath}] does not exists, stopping hubot process");
  else
    console.log "{[pokusbot]} - found [#{pokusPrivateSSHKeyPath}] ssh private key located at [#{pokusPrivateSSHKeyPath}]"

  if !fs.existsSync(pokusPublicSSHKeyPath)
    throw new Error("{[pokusbot]} - [#{pokusPublicSSHKeyPath}] does not exists, stopping hubot process");
  else
    console.log "{[pokusbot]} - found [#{pokusPublicSSHKeyPath}] ssh public key located at [#{pokusPublicSSHKeyPath}]"


  console.log "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  console.log "# -- # --    Successfully Completed FETCHING HUBOT's SECRET SSH KEYS FROM VAULT! "
  console.log "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"

  # //***
  # //* /pokus/run/lib/ssh-git-config.sh completes the git ssh configuration (and soon a [gpg-git-config.sh] ), just assuming th 2 SSSH KEys are well formated and exists at the following path :
  # //*
  # //* - /home/hubot/pokus/secrets/.ssh/id_rsa
  # //* - /home/hubot/pokus/secrets/.ssh/id_rsa.pub
  # //*
  # //***/
  # //
  # // GIT_USER_NAME   =>> pokusGitUserNamePath
  # // GIT_USER_EMAIL   =>> pokusGitUserEmailPath
  # // GIT_USER_GPG_SIGNING_KEY   =>> pokusGitUserGpgSingingKeyPath
  # // GIT_SSH_COMMAND ? POKUS_GIT_SSH_CMD ? = process.env.POKUS_GIT_SSH_CMD
  if shell.exec("export GIT_SSH_COMMAND='#{gitSSHCommand}' && export GIT_USER_NAME=$(cat #{pokusGitUserName}) && export GIT_USER_EMAIL=$(cat #{pokusGitUserEmail}) && export GIT_USER_GPG_SIGNING_KEY=$(cat #{pokusGitUserGpgSingingKey}) && /pokus/run/lib/ssh-git-config.sh").code != 0
    # // Run external tool synchronously
    shell.echo('Error: executing the [/pokus/run/lib/ssh-git-config.sh] shell script');
    shell.echo("Error Env: [export GIT_SSH_COMMAND='#{gitSSHCommand}' && export GIT_USER_NAME=$(cat #{pokusGitUserName}) && export GIT_USER_EMAIL=$(cat #{pokusGitUserEmail}) && export GIT_USER_GPG_SIGNING_KEY=$(cat #{pokusGitUserGpgSingingKey})] ");
    shell.exit(1);
  else
    shell.echo('Executing the [/pokus/run/lib/ssh-git-config.sh] shell script succeeded');

  console.log "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"
  console.log "# -- # --    Successfully Completed the git ssh configuration! "
  console.log "# -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- # -- #"



  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- -+- ROBOT HEARS
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-

  # robot.hear /deploy/i, (res) ->
  robot.hear /deploie/i, (res) ->
    # your code here
    trucName = res.match[0]
    serviceName = res.match[1]
    paramTwo = res.match[2]
    res.reply 'I am the Bernard Bot'
    res.reply 'Now deploying your Hugo Website...'
    res.reply "Deployment target trucName is: [#{trucName}]"
    res.reply "Deployment target serviceName is: [#{serviceName}]"
    res.reply "Deployment target paramTwo is: [ #{paramTwo}]"
    if shell.exec('echo "petit test jbl" > ./PETIT_TEST_JBL.md').code != 0
      # // Run external tool synchronously
      shell.echo('Error: creating ./PETIT_TEST_JBL.md failed');
      shell.exit(1);
      # 'Error: creating ./PETIT_TEST_JBL.md failed'
    else
      # 'Creating ./PETIT_TEST_JBL.md succeeded'
      shell.echo('Creating ./PETIT_TEST_JBL.md succeeded');
    res.reply 'I am the Bernard Bot'
    res.reply 'Deploying your Hugo Website completed!...'

  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
  # // +- -+- -+- ROBOT RESPONDS
  # // +- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-

  robot.respond /(deploy|shoot)[ ]?(.*)?/i, (msg) ->
    users = msg.match[2] or null

    if users?

      usersArray = users.split ' '

      # giveEmTheBoot msg, user for user in users.split ' '
      for user in users.split ' '
        msg.reply "Deployment target param is: [#{user}]"

      domainName  = usersArray[0]
      gitSshUri  = usersArray[1]
      gitVersion  = usersArray[2]
      hugoThemeSsh = usersArray[3]
      hugoThemeVersion = usersArray[4]
      gitSSHCommand = process.env.POKUS_GIT_SSH_CMD
      envGitSshCmd = process.env.GIT_SSH_COMMAND

      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"
      msg.reply "   Deployment target domainName is: [#{domainName}]"
      msg.reply "   Deployment target gitSshUri is: [#{gitSshUri}]"
      msg.reply "   Deployment target gitVersion is: [#{gitVersion}]"
      msg.reply "   Deployment target hugoThemeSsh is: [#{hugoThemeSsh}]"
      msg.reply "   Deployment target hugoThemeVersion is: [#{hugoThemeVersion}]"
      msg.reply "   Deployment target POKUS_GIT_SSH_CMD is: [#{gitSSHCommand}]"
      msg.reply "   Deployment target GIT_SSH_COMMAND is: [#{envGitSshCmd}]"
      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"

      console.log "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"
      console.log "   Deployment target domainName is: [#{domainName}]"
      console.log "   Deployment target gitSshUri is: [#{gitSshUri}]"
      console.log "   Deployment target gitVersion is: [#{gitVersion}]"
      console.log "   Deployment target hugoThemeSsh is: [#{hugoThemeSsh}]"
      console.log "   Deployment target hugoThemeVersion is: [#{hugoThemeVersion}]"
      console.log "   Deployment target POKUS_GIT_SSH_CMD is: [#{gitSSHCommand}]"
      console.log "   Deployment target GIT_SSH_COMMAND is: [#{envGitSshCmd}]"
      console.log "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"
      console.log "+- -+- -+- -+- NODEJS PROCCESS.ENV : "
      console.log(process.env)
      console.log "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"

      if shell.exec("echo 'petit test jbl' > ./PETIT_TEST_JBL.md && echo '   Deployment target domainName is: [#{usersArray[0]}]' | tee -a ./PETIT_TEST_JBL.md && echo '   Deployment target gitSshUri is: [#{usersArray[1]}]' | tee -a ./PETIT_TEST_JBL.md && echo '   Deployment target gitVersion is: [#{usersArray[2]}]' | tee -a ./PETIT_TEST_JBL.md").code != 0
        # // Run external tool synchronously
        shell.echo('Error: creating ./PETIT_TEST_JBL.md failed');
        shell.exit(1);
        # 'Error: creating ./PETIT_TEST_JBL.md failed'
      else
        # 'Creating ./PETIT_TEST_JBL.md succeeded'
        shell.echo('Creating ./PETIT_TEST_JBL.md succeeded');


      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"
      msg.reply '  I am the Bernard Bot: Now checking my ssh keys...'
      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"

      console.log "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"
      console.log '  I am the Bernard Bot: Now checking my ssh keys...'
      console.log "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"

      if shell.exec("pwd && ls -alh /pokus/secrets/.ssh/id_rsa.pub").code != 0
        # // Run external tool synchronously
        shell.echo('Error: /pokus/secrets/.ssh/id_rsa.pub does not exist');
        shell.exit(1);
        msg.reply "Error: /pokus/secrets/.ssh/id_rsa.pub does not exist"
      else
        # 'Good,  [/pokus/secrets/.ssh/id_rsa.pub] does exist indeed.'
        shell.echo('Good,  [/pokus/secrets/.ssh/id_rsa.pub] does exist indeed.');

      if shell.exec("pwd && ls -alh /pokus/secrets/.ssh/id_rsa").code != 0
        # // Run external tool synchronously
        shell.echo('Error: /pokus/secrets/.ssh/id_rsa does not exist');
        shell.exit(1);
        msg.reply "Error: /pokus/secrets/.ssh/id_rsa does not exist"
      else
        # 'Good,  [/pokus/secrets/.ssh/id_rsa] does exist indeed.'
        shell.echo('Good,  [/pokus/secrets/.ssh/id_rsa] does exist indeed.');

      console.log "################# CHECK SSH PUUB KEY FOR GITHUB.COM"
      if shell.exec("cat /pokus/secrets/.ssh/id_rsa.pub").code != 0
        # // Run external tool synchronously
        shell.echo("Error executing [cat /pokus/secrets/.ssh/id_rsa.pub]");
        shell.exit(1);
      else
        # 'Creating ./PETIT_TEST_JBL.md succeeded'
        shell.echo "executing [cat /pokus/secrets/.ssh/id_rsa.pub] succeeded"


      console.log "################# SSH KEYSCAN GITHUB.COM"
      if shell.exec("ssh-keyscan -vvv -t rsa -p 22 -H github.com && mkdir -p ~/.ssh/ && ssh-keyscan -t rsa -p 22 -H github.com >> ~/.ssh/known_hosts ").code != 0
        # // Run external tool synchronously
        shell.echo("Error executing [ssh-keyscan -vvv -t rsa -p 22 -H github.com && mkdir -p ~/.ssh/ && ssh-keyscan -t rsa -p 22 -H github.com >> ~/.ssh/known_hosts]");
        # // shell.exit(1);
      else
        # 'Creating ./PETIT_TEST_JBL.md succeeded'
        shell.echo "executing [ssh-keyscan -vvv -t rsa -p 22 -H github.com && mkdir -p ~/.ssh/ && ssh-keyscan -t rsa -p 22 -H github.com >> ~/.ssh/known_hosts] succeeded"


      console.log "################# TESTING SSH AGAINST GITHUB.COM"
      if shell.exec("#{gitSSHCommand} -T git@github.com || true").code != 0
        # // Run external tool synchronously
        shell.echo("Error executing [#{gitSSHCommand} -T git@github.com]");
        shell.exit(1);
      else
        # 'Creating ./PETIT_TEST_JBL.md succeeded'
        shell.echo "executing [#{gitSSHCommand} -T git@github.com] succeeded"

      # ---
      # Installing both golang and hugo into the
      # hubot container will not be easy:
      # so i'd prefer let a drone pipeline :
      # For PR git branches: make a git commit and push with the Hubot, which triggers a drone pipeline, and execute the golang/hugo build, and then the deployment to surge.sh,
      # For Releases: 2 possibilities :
      #         OPTION 1 : make a git flow release autamatically with the hubot (just git flow release start), which triggers automatically the pipeline for the release, making the hugo build(put it all in [docs/] github page folders) and a git commit an push on the release git branch, to finally finish th egit flow release [git flow realease finish -s]
      #         OPTION 2 : make a curl against the Drone CI REST API to trigger a pipeline, which runs the whole git flow release git the hugo build etc...
      #         ALL OPTIONS : on the git release tag, the docs/ folder MUST befilled with the result of the hugo build, and no other commit on amster than the release tagged one.
      # encapsulates the golang / hugo system with git etc... :
      # and inside the bot , I trigger drone pipelines by git commits and push, and eventually curl the Drone Rest API to trigger a particular pipeline
      # ---
      # commandAsText = "export GIT_SSH_COMMAND='#{gitSSHCommand}' && git clone #{gitSshUri} wow-bellerophon-bot/ && cd wow-bellerophon-bot/ && git checkout #{gitVersion} && rm -fr .git/ && export HUGO_THEME_GIT_SSH=#{hugoThemeSsh} && git clone ${HUGO_THEME_GIT_SSH} themes/clean-white && cd themes/clean-white  && git checkout #{hugoThemeVersion} && cd ../.. && rm -fr themes/clean-white/.git/ && export HUGO_BASE_URL=#{domainName} && hugo -b ${HUGO_BASE_URL} && hugo serve -b http://127.0.0.1:4545 -p 4545 --bind 127.0.0.1 -w "
      commandAsText = "export GIT_SSH_COMMAND='#{gitSSHCommand}' && git clone #{gitSshUri} wow-bellerophon-bot/ && cd wow-bellerophon-bot/ && git checkout #{gitVersion} && rm -fr .git/ && export HUGO_THEME_GIT_SSH=#{hugoThemeSsh} && git clone ${HUGO_THEME_GIT_SSH} themes/clean-white && cd themes/clean-white  && git checkout #{hugoThemeVersion} && cd ../.. && rm -fr themes/clean-white/.git/"
      if shell.exec("#{commandAsText}").code != 0
        # // Run external tool synchronously
        shell.echo "Error executing : [#{commandAsText}]"
        shell.exit(1);
        # 'Error: creating ./PETIT_TEST_JBL.md failed'
      else
        # 'Creating ./PETIT_TEST_JBL.md succeeded'
        shell.echo "Executing [#{commandAsText}] succeeded"

      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"
      msg.reply '  I am the Bernard Bot'
      msg.reply '  Deploying your Hugo Website completed!...'
      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"


    else
      msg.reply "Sorry, you did not provide the 3 required arguments : "
      msg.reply "  -+- Deployment target [domainName]"
      msg.reply "  -+- Deployment target [gitSshUri]"
      msg.reply "  -+- Deployment target [gitVersion]"
      msg.reply "  -+- Deployment target [gitSshUri]"
      msg.reply "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"


  # robot.respond /deploie  (.*)/i, (res) ->
    # # your code here
    # # your code here
    # res.reply 'open the pod bay doors to bernard'
    # serviceName = res.match[1]
    # paramTwo = res.match[2]
    # res.reply 'I am the Bernard Bot'
    # res.reply 'Now deploying your Hugo Website...'
    # res.reply "Deployment target serviceName is: [#{serviceName}]"
    # res.reply "Deployment target paramTwo is: [ #{paramTwo}]"

    # robot.respond /open the (.*) doors/i, (res) ->
     # doorType = res.match[1]
     # if doorType is "pod bay"
       # res.reply "I'm afraid I can't let you do that."
     # else
       # res.reply "Opening #{doorType} doors"
