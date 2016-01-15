# Description:
#   Sends a welcome message to the first thing someone new says something
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot welcome <new welcome message> - Update the welcome message
#
# Author:
#   jjasghar
#   https://github.com/jjasghar/hubot-welcome

module.exports = (robot) ->
  robot.enter (msg) ->
    room = msg.message.room
    stored_users = robot.brain.get("data.users.#{room}") ? [] # get a list of the known stored users
    users = robot.brain.usersForFuzzyName("#{msg.message.user.name}") # get the user name of someone saying something
    if users in stored_users # if the user above is in the stored_users do nothing
    else
      welcome = robot.brain.get("data.welcome.#{room}") ? "welcome"
      msg.reply welcome # if it's the first time you're seeing them give them the welcome message
      stored_users.push msg.message.user.name
      robot.brain.set "data.users.#{room}", stored_users


  robot.respond /welcome (.*)$/i, (msg) ->
    room = msg.message.room
    welcome = msg.match[1]
    robot.brain.set "data.welcome.#{room}", welcome.trim()
    msg.send "Updated the welcome to: #{welcome}"
