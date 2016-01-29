# Description:
#   Shuffling tool
#
# Commands:
#   hubot shuffle [items] - output shuffled items

shuffle = (arr) ->
  arr = arr.slice()
  i = arr.length
  if i == 0
    return arr;
  while --i
    j = Math.floor(Math.random() * (i + 1))
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
  return arr

module.exports = (robot) ->
  robot.respond /SHUFFLE ?(.*)$/i, (msg) ->
    attr = msg.match[1].trim()
    unless attr
      msg.reply "引数が必要です"
      return

    arr = attr.split(/\s+/)
    msg.send shuffle(arr).join(" ")
