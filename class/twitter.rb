class TWITTER
  def initialize data
    # require
    require 'selenium-webdriver'
    

    str_account_info = ""
    File.open(path=data[:path]) do |file|
      file.each do |text|
        str_account_info += text
      end
    end
    account_info = JSON.parse str_account_info
    user_name = account_info[:name]
    user_pass = account_info[:pass]

    webdriver = Selenium::WebDriver.for :chrome
    webdriver.get 'https://twitter.com/i/flow/login'
    name = webdriver.find_elements(:CSS_selector, ".r-30o5oe.r-1dz5y72.r-13qz1uu.r-1niwhzg.r-17gur6a.r-1yadl64.r-deolkf.r-homxoj.r-poiln3.r-7cikom.r-1ny4l3l.r-t60dpp.r-fdjqy7")
    puts name
    gets
  end
end