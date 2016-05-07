# Description:
#   ダイスロール
#
# Commands:
#   hubot [amount]D[face] - [face]面ダイスを[amount]個振って合計値を求める

roll = (amount, face) ->
  res = []
  total = 0
  while amount--
    tmp = Math.floor(Math.random() * face) + 1
    res.push(tmp)
    total += tmp
  return [total, res]

module.exports = (robot) ->
  robot.respond /(\d+)D(\d+)$/i, (msg) ->
    amount = parseInt(msg.match[1].trim())
    face = parseInt(msg.match[2].trim())
    [total, result] = roll(amount, face)
    msg.reply "#{total} -> [#{result.join(", ")}]"
