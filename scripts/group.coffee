# Description:
#   Grouping tool
#
# Commands:
#   hubot group [number] [items] - 空白区切りの文字列をシャッフルして[nubmer]個にグループ分けする


shuffle = (arr) ->
  arr = arr.slice()
  i = arr.length
  if i == 0
    return arr
  while --i
    j = Math.floor(Math.random() * (i + 1))
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
  return arr

grouping = (number, arr) ->
  arr = shuffle(arr)

  res = []
  base_size = Math.floor(arr.length / number)
  fraction = arr.length % number

  pivot = 0
  while pivot < arr.length
    if fraction > 0
      size = base_size + 1
      fraction--
    else
      size = base_size

    res.push(arr.slice(pivot, pivot + size))
    pivot = pivot + size
  return res

module.exports = (robot) ->
  robot.respond /GROUP (\d+) ?(.*)$/i, (msg) ->
    number = parseInt(msg.match[1].trim())
    if number <= 0
      msg.reply "グループ数は1以上の値にしてください"
      return

    attr = msg.match[2].trim()
    unless attr
      msg.reply "引数が必要です"
      return

    arr = attr.split(/\s+/)
    res = ""
    for val, i in grouping(number, arr)
      res += "#{i}:santeam: #{val.join(", ")}\n"
    msg.send res
