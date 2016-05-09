# Description:
#   KOSEN10S LT 準備ツール
#
# Commands:
#   hubot lt start - LTの準備を始める
#   hubot lt start <name> - nameをチャンネル名としてLTの準備を始める。ナンバリングは更新されない。
#   hubot lt next <number> - LTのナンバリングを設定する
#   hubot lt last <number> - LTのナンバリングを設定する
#   hubot lt info - 次回LTのナンバリングを確認する
#   hubot lt check - lt startを実行する権限があるか確認する


WebClient = require("slack-client").WebClient
client = new WebClient(process.env.SLACK_API_TOKEN)
github = require('githubot')

issues = [
  "日付決定"
  "会場手配"
  "タイムスケジュール作成"
  "場内での飲食物に関する調査"
  "Doorkeeperでのイベント作成"
  "懇親会の企画"
  "当日の運営手伝いマンにやってもらうことをリスト化"
  "当日の必要物品リストの作成"
  "会計収支表作成"
  "ロゴ・オープニング・エンディング・名刺"
]

zero_padding = (num) ->
  ("0" + num).slice(-2)

add_issues = (repo_name, i = 0) ->
  if i < issues.length
    github.post "/repos/kosen10s/#{repo_name}/issues", {title: issues[i]}, (res) ->
      add_issues(repo_name, res.number)

init_github = (repo_name, msg)->
  github.post "orgs/kosen10s/repos", {name: repo_name}, (res) ->
    msg.send "Created #{repo_name}: #{res.html_url}"
    add_issues repo_name

init_slack = (channel_name, msg) ->
  client.channels.create channel_name, (err, res) ->
    if err
      msg.send "Error:#{err}"
    else
      msg.send "Created \##{channel_name} channel"

module.exports = (robot) ->
  robot.respond /LT START ?(.*)$/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user, "lt")
      if msg.match[1]
        channel_name = msg.match[1]
      else
        lt_next_num = robot.brain.get("lt.next") ? 1
        channel_name = "lt#{zero_padding lt_next_num}"
        lt_next_num += 1
        robot.brain.set "lt.next", lt_next_num

      repo_name = channel_name + "docs"

      init_slack channel_name, msg
      init_github repo_name, msg
    else
      msg.reply "コマンドを実行する権限がありません"

  robot.respond /LT NEXT ?(\d*)$/i, (msg) ->
    lt_next_num = parseInt msg.match[1]
    robot.brain.set "lt.next", lt_next_num
    msg.send "次回ナンバリングを#{zero_padding lt_next_num}にしました"

  robot.respond /LT LAST ?(\d*)$/i, (msg) ->
    lt_next_num = (parseInt msg.match[1]) + 1
    robot.brain.set "lt.next", lt_next_num
    msg.send "次回ナンバリングを#{zero_padding lt_next_num}にしました"

  robot.respond /LT INFO ?(\d*)$/i, (msg) ->
    lt_next_num = robot.brain.get("lt.next") ? 1
    msg.reply "次回: lt#{zero_padding lt_next_num}"

  robot.respond /LT CHECK$/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user, "lt")
      msg.reply "権限があります"
    else
      msg.reply "権限がありません"
