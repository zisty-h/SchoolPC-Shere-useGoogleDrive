require 'net/http'
require 'uri'
require 'json'

# ツイートの本文
tweet_text = "これはテストツイートです。"

# Twitter API v2ツイート投稿エンドポイント
endpoint = URI("https://api.twitter.com/2/tweets")

# ツイートデータの準備（本文）
tweet_data = { "text" => tweet_text }

# Twitter APIへのHTTP POSTリクエスト
http = Net::HTTP.new(endpoint.host, endpoint.port)
http.use_ssl = true

request = Net::HTTP::Post.new(endpoint)
request["Authorization"] = "1615290705458630656-mUqefJh8ZmQWwTsBlm9ZM5716QsA2B"
request["Content-Type"] = "application/json"
request.body = tweet_data.to_json

response = http.request(request)

# レスポンスの処理
if response.code == "201"
  puts "ツイートが投稿されました。"
else
  puts "Error: #{response.code} - #{response.message}"
end