# Description:
#   Choice one
#
# Commands:
#   hubot choice [items] - 空白区切りの要素の中から、ランタムに１つ選んで表示

choice = (arr) ->
  arr = arr.slice()
  index = Math.floor(Math.random() * (arr.length))
  return arr[index]

module.exports = (robot) ->
  robot.respond /CHOICE ?(.*)$/i, (msg) ->
    attr = msg.match[1].trim()
    unless attr
      msg.reply "引数が必要です"
      return

    arr = attr.split(/\s+/)
    msg.send choice(arr)
