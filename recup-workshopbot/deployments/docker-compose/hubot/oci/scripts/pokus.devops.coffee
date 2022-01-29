# Description:
#   Tell people hubot's new name if they use the old one
#
# Commands:
#   None
#
shell = require('shelljs');
module.exports = (robot) ->
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
