# Description:
#   Pugme is the most important thing in life
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pug me - Receive a pug
#   hubot pug bomb N - get N pugs

module.exports = (robot) ->

  robot.respond /pug me/i, (msg) ->
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG MEEEE ')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG MEEEE ')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG MEEEE ')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG MEEEE ')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG MEEEE ')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG MEEEE ')

    msg.http("http://pugme.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.reply "Non mais je rêve"
        msg.send JSON.parse(body).pug

  robot.respond /pug bomb( (\d+))?/i, (msg) ->

    count = msg.match[2] || 5
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG BOMB BOMB count=[' + count + ']')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG BOMB BOMB count=[' + count + ']')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG BOMB BOMB count=[' + count + ']')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG BOMB BOMB count=[' + count + ']')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG BOMB BOMB count=[' + count + ']')
    console.log('ALOOOOOOOOOOOOOO  C JBL JBL JBL JBL JBL JBL JBL PUGGGG BOMB BOMB count=[' + count + ']')
    msg.http("http://pugme.herokuapp.com/bomb?count=" + count)
      .get() (err, res, body) ->
        msg.send pug for pug in JSON.parse(body).pugs

  robot.respond /how many pugs are there/i, (msg) ->
    msg.http("http://pugme.herokuapp.com/count")
      .get() (err, res, body) ->
        msg.send "There are #{JSON.parse(body).pug_count} pugs."
