require 'json'
require 'json'
require 'nokogiri'
require 'net/http'
Book_base_url = "https://ncode.syosetu.com/"
Api_base_url = "https://api.syosetu.com/novelapi/api?out=json&ncode="
print_text = ""
File.open(path="./data/print", mode="r") do |file|
  file.each do |text|
    print_text += text
  end
end
puts print_text
# main loop
while true
  print "Book id $ "
  book_id = gets.chomp!
  if book_id == "exit"
    exit
  end
  book_url = "#{Book_base_url}#{book_id}/"
  api_url = "#{Api_base_url}#{book_id}"
  puts "[INFO] Book url: #{book_url}\n[INFO] Api url: #{api_url}"
  api_response = JSON.parse Net::HTTP.get_response(URI.parse(api_url)).body
  puts api_response[1]
  book_title = api_response[1]["title"]
  general_all_no = api_response[1]["general_all_no"]
  puts "[INFO] Title: #{book_title}\n[INFO] General all no: #{general_all_no.to_s}"
  puts "Start download."
  book_text = ""
  (1..general_all_no).each do |i|
    url = URI.parse book_url + i.to_s
    puts "Download: #{url}. #{i.to_s}/#{general_all_no.to_s}"
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")

    request = Net::HTTP::Get.new(url)
    request.add_field('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36')

    response = http.request(request)

    html = Nokogiri.parse response.body
    data = html.css("#novel_honbun")[0]

    book_text += data.content
  end

  File.open(path="#{book_title}.txt", mode="w") do |file|
    file.write book_text
  end
  system "start \"#{book_text}.txt\""
end