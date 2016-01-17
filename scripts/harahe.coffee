# Description:
#   Get restaurant data from Gurunavi API
#
# Original:
#   https://gist.github.com/taketin/146d1412d11f5596770b
#
# Commands:
#   hubot harahe - Reply with restaurant info
#   hubot osake  - Reply with restaurant info
#   hubot sake   - Reply with restaurant info
#   hubot lunch  - Reply with restaurant info
#   hubot oyatsu - Reply with restaurant info
#   hubot oyatu  - Reply with restaurant info

Client = require("node-rest-client").Client
client = new Client()
stringify = require("querystring").stringify

keyid       = process.env.HUBOT_HARAHE_TOKEN
apiHost     = 'http://api.gnavi.co.jp/RestSearchAPI/20150630/?'

sendRestaurant = (msg, query, prefix = '', budgetKey = 'budget') ->
  formatBudget = (budget) -> if typeof budget == 'string' then "#{budget}円" else "不明"
  request = apiHost + stringify(query)

  client.get request, (data, res) ->
    response = JSON.parse(data)
    if response['error']
      msg.reply response['error']['message']
      return

    page = Math.floor Math.random() * Math.min(response['total_hit_count'], response['hit_per_page'])
    restaurant = if response['total_hit_count'] == '1' then response['rest'] else response['rest'][page]
    msg.send """
    #{prefix}#{restaurant['name']}

    カテゴリ: #{restaurant['category']}
    平均予算: #{formatBudget(restaurant[budgetKey])}
    住所: #{restaurant['address']}
    #{restaurant['url']}
    """

module.exports = (robot) ->
  robot.respond /HARAHE ?(.*)$/i, (msg) ->
    query = {
      keyid: keyid
      hit_per_page: 20
      address: msg.match[1].trim()
      format: 'json'
    }
    sendRestaurant(msg, query)

  robot.respond /O?SAKE ?(.*)$/i, (msg) ->
    query = {
      keyid: keyid
      hit_per_page: 20
      address: msg.match[1].trim()
      freeword: '酒'
      format: 'json'
    }
    sendRestaurant(msg, query, ':sake:')

  robot.respond /LUNCH ?(.*)$/i, (msg) ->
    query = {
      keyid: keyid
      hit_per_page: 20
      address: msg.match[1].trim()
      lunch: 1
      format: 'json'
    }
    sendRestaurant(msg, query, '', 'lunch')

  robot.respond /OYATS?U ?(.*)$/i, (msg) ->
    query = {
      keyid: keyid
      hit_per_page: 20
      address: msg.match[1].trim()
      freeword: 'カフェ・スイーツ'
      format: 'json'
    }
    sendRestaurant(msg, query, ':cake:')
