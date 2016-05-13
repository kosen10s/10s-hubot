# Description:
#   Tweet tool
#
# Commands:
#   hubot tweet <text> - Twitterにつぶやく
Twitter = require("twitter")

post = (msg, tweet) ->
  option = {
    consumer_key: process.env.TWITTER_CONSUMER_KEY
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET
    access_token_key: process.env.TWITTER_ACCESS_TOKEN_KEY
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
  }
  client = new Twitter(option)
  client.post 'statuses/update', {status: tweet}, (error, tweet, response) ->
    if !error
      msg.reply ":done:"
    else
      msg.reply "ツイートに失敗しました\n#{JSON.stringify(error)}"

module.exports = (robot) ->
  robot.respond /TWEET ?(.*)$/i, (msg) ->
    tweet = msg.match[1].trim()
    unless tweet
      msg.reply "ツイートする文章が必要です"
      return

    post(msg, tweet)
