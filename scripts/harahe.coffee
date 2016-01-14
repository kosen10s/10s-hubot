# Description:
#   Get restaurant data from Gurunavi API
#
# Original:
#   https://gist.github.com/taketin/146d1412d11f5596770b
#
# Commands:
#   hubot harahe - Reply with restaurant info

Client = require("node-rest-client").Client
client = new Client()
parseString = require('xml2js').parseString

keyId       = process.env.HUBOT_HARAHE_TOKEN
address     = ''
apiHost     = 'http://api.gnavi.co.jp/RestSearchAPI/20150630/?'
hitPerPage  = 1

module.exports = (robot) ->
  robot.respond /HARAHE ?(.*)$/i, (msg) ->
    attr = msg.match[1].trim()
    address = attr if attr != ""
    req = "#{apiHost}keyid=#{keyId}&hit_per_page=#{hitPerPage}&offset_page=1&address=#{encodeURIComponent(address)}"

    client.get req, (data, response) ->
      parseString data, (err, result) ->
        try
          totalCount = result['response']['total_hit_count']
          offsetPage = Math.floor Math.random() * totalCount
          req = "#{apiHost}keyid=#{keyId}&hit_per_page=#{hitPerPage}&offset_page=#{offsetPage}&address=#{encodeURIComponent(address)}"

          client.get req, (data, response) ->
            parseString data, (err, result) ->
              formatBudget = (budget) -> if budget then "#{budget}円" else "不明"
              items = result['response']['rest'][0]
              msg.send """
              #{items['name']}

              カテゴリ: #{items['category']}
              平均予算: #{formatBudget(items['budget'])}
              住所: #{items['address']}
              #{items['url']}
              """
        catch
          msg.send "Not Found..."
