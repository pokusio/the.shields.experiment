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

      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"
      msg.reply "   Deployment target domainName is: [#{domainName}]"
      msg.reply "   Deployment target gitSshUri is: [#{gitSshUri}]"
      msg.reply "   Deployment target gitVersion is: [#{gitVersion}]"
      msg.reply "   Deployment target hugoThemeSsh is: [#{hugoThemeSsh}]"
      msg.reply "   Deployment target hugoThemeVersion is: [#{hugoThemeVersion}]"
      msg.reply "+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-"


      if shell.exec("echo 'petit test jbl' > ./PETIT_TEST_JBL.md && echo '   Deployment target domainName is: [#{usersArray[0]}]' | tee -a ./PETIT_TEST_JBL.md && echo '   Deployment target gitSshUri is: [#{usersArray[1]}]' | tee -a ./PETIT_TEST_JBL.md && echo '   Deployment target gitVersion is: [#{usersArray[2]}]' | tee -a ./PETIT_TEST_JBL.md").code != 0
        # // Run external tool synchronously
        shell.echo('Error: creating ./PETIT_TEST_JBL.md failed');
        shell.exit(1);
        # 'Error: creating ./PETIT_TEST_JBL.md failed'
      else
        # 'Creating ./PETIT_TEST_JBL.md succeeded'
        shell.echo('Creating ./PETIT_TEST_JBL.md succeeded');


      if shell.exec("git clone #{gitSshUri} wow-bellerophon-bot/ && cd wow-bellerophon-bot/ && git checkout #{gitVersion} && rm -fr .git/ && export HUGO_THEME_GIT_SSH=#{hugoThemeSsh} && git clone ${HUGO_THEME_GIT_SSH} themes/clean-white && cd themes/clean-white  && git checkout #{hugoThemeVersion} && cd ../.. && rm -fr themes/clean-white/.git/ && export HUGO_BASE_URL=#{domainName} && hugo -b ${HUGO_BASE_URL} && hugo serve -b http://127.0.0.1:4545 -p 4545 --bind 127.0.0.1 -w ").code != 0
        # // Run external tool synchronously
        shell.echo('Error: creating ./PETIT_TEST_JBL.md failed');
        shell.exit(1);
        # 'Error: creating ./PETIT_TEST_JBL.md failed'
      else
        # 'Creating ./PETIT_TEST_JBL.md succeeded'
        shell.echo('Creating ./PETIT_TEST_JBL.md succeeded');

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
