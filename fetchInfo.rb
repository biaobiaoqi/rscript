#encoding=UTF-8
require 'httpclient'
require 'nokogiri'

   def get_page n 
      client = HTTPClient.new
      uri = 'http://wszw.hzs.mofcom.gov.cn/fecp/fem/corp/fem_cert_stat_view_list.jsp?manage=0&check_dte_nian=1980&check_dte_nian2=2013&check_dte_yue=01&check_dte_yue2=12&CERT_NO=&COUNTRY_CN_NA=&CORP_NA_CN=&CHECK_DTE='
      body = "Grid1toPageNo=#{n}&Grid1CurrentPage=2&PageFlag=1"
      extheader = {
	    'POST' => '/fecp/fem/corp/fem_cert_stat_view_list.jsp HTTP/1.1',
		'Host' =>  'wszw.hzs.mofcom.gov.cn',
		'Connection' => 'keep-alive',
		'Content-Length' => '45',
		'Cache-Control' => 'max-age=0',
		'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
		'Origin' => 'http://wszw.hzs.mofcom.gov.cn',
		'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36',
		'Content-Type' => 'application/x-www-form-urlencoded',
		'Referer' => 'http://wszw.hzs.mofcom.gov.cn/fecp/fem/corp/fem_cert_stat_view_list.jsp',
		'Accept-Encoding' => 'gzip,deflate,sdch',
		'Accept-Language' => 'zh-CN,zh;q=0.8,zh-TW;q=0.6',
		'Cookie' => 'JSESSIONID=363B7AD79CFB8638E530A92CD75BA693; BIGipServerfecp_server_pool=1795512531.20480.0000',
      }
      response = client.post_content(uri, body, extheader)
      response = response.encode('utf-8','gbk')
   end

   puts '#帮小文写的爬虫'
   puts '#爬取http://wszw.hzs.mofcom.gov.cn/fecp/fem/corp/fem_cert_stat_view_list.jsp 1-1404页的数据'
   puts '#用csv个数存储'
   puts '===beigin==='

   result_file = File.new("out.csv", "w")
   result_file.puts "证书号, 国家/地区, 境内投资主体, 境外投资企业（机构）, 省市, 经营范围, 核准日期, 境外注册日期"

   for i in 1176..1345
      content = get_page i
      page = Nokogiri::HTML(content)
      page.css("tr[class='listTableBody']").each do |line|
         line.css("div").each do |element|
         	value = element.text
         	value.gsub!(/,/, "，")
            value.gsub!(/\n/, "；")
         	result_file.print "#{value}, " unless value == ""
         end
         result_file.puts ""
      end
      puts "完成第#{i}页爬取"
   end

   result_file.close

   puts "===end==="


   