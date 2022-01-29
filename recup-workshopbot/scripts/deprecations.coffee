# Description:
#   Tell users when they have used commands that are deprecated or renamed
#
# Commands:
#   None
#
module.exports = (robot) ->
  robot.respond /help\s*(.*)?$/i, (res) ->
    res.reply "That means nothing to me anymore. Perhaps you meant `docs` instead?"
    return

#
module.exports = (robot) ->
  robot.respond /vieille\s*(.*)?$/i, (res) ->
    res.reply "That means nothing to me anymore. Perhaps you meant `docs` instead?"
    return

#
module.exports = (robot) ->
  robot.respond /yoga\s*(.*)?$/i, (res) ->
    res.reply "That means nothing to me anymore. Perhaps you meant `docs` instead?"
    return
