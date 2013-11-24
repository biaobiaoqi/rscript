#encoding=UTF-8
require 'httpclient'
require 'nokogiri'

   puts "#抓取全国高校地址信息（学校名 所在城市）"
   puts "#信息来源：http://learning.sohu.com/20130702/n380444032.shtml"
   puts "#全国成人高校名单和全国民办成人高校名单中没有城市信息，没有纳入爬取范围"
   puts "===start==="
   result_file = File.open("school_location_info.txt", "w")
   
   client = HTTPClient.new
   response = client.get_content('http://learning.sohu.com/20130702/n380444032.shtml')
   response = response.encode('utf-8','gbk')
   index_page = Nokogiri::HTML(response)
   index_page.css("div[itemprop='articleBody']").css("a").each do |a|
      #get school and location info
      ref = a['href']
      puts ref
      
      response = client.get_content(ref)
      response = response.encode('utf-8', 'gbk')
      info_page = Nokogiri::HTML(response)
      info_page.css("div[itemprop='articleBody']").css('tr').each do |line|
         elements = line.css('td')
         #if elements[0].is_a?(Integer) then
         if elements.size == 5 && elements[0].text.to_i != 0 then
            school = elements[1].text
            city = elements[3].text
            result_file.puts "#{school} #{city}"
         end
      end
   end

   result_file.close
   puts "===end==="