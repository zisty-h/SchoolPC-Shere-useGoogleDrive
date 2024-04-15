require 'sinatra'
require 'nokogiri'
require 'net/http'
require 'json'

Book_base_url = "https://ncode.syosetu.com/"
Api_base_url = "https://api.syosetu.com/novelapi/api?out=json"

def decode text
  text.unpack("U*").map{ |char| [char].pack('U') }.join
end

get "/" do
  "Hello world!"
end
get "/book" do
  book_id = params[:ncode]
  puts "Book id is #{book_id}"
  api_url = "#{Api_base_url}&ncode=#{book_id}"
  book_url = "#{Book_base_url}#{book_id}/"
  puts "URL: #{api_url}"
  response = JSON.parse Net::HTTP.get_response(URI.parse(api_url)).body
  book_data = response[1]
  # puts book_data
  book_title = decode text=book_data["title"]
  all_books = book_data["general_all_no"]
  puts "Book title: #{book_title}"
  puts "General all no: #{all_books.to_s}"
  puts "Start download."
  book_text = ""
  (1..all_books).each do |no|
    url = "#{book_url}#{no.to_s}/"
    puts "url: #{url}. #{no.to_s}/#{all_books.to_s}"
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    request = Net::HTTP::Get.new(url)
    request.add_field('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36')
    response = http.request(request)

    html = Nokogiri.parse response.body
    data = html.css('#novel_honbun')[0]
    puts "Class: #{data.class}"
    book_text = "#{book_text}\n#{data.content}"
  end
  file = "#{book_title}.txt"
  File.open(path=file, mode="w") do |file|
    file.write(book_text)
  end
  send_file file
end
