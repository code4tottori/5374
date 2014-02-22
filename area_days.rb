# coding: utf-8

require 'nokogiri'
require 'open-uri'
require 'nkf'
require 'tempfile'

def convert_date (line)
  return line unless line.start_with?("第")

  numbers = line.scan(/\d+/)
  days = line.scan(/[月火水木金土日]/)
  day = days[0]
  convert = ""
  numbers.each { |num|
    convert << day.chomp
    convert << num.chomp
    convert << ' '
  }
  return convert.strip
end

def export cities
  cities.each_with_index { |city,i|
    str = NKF.nkf('-m0Z1 -w', city.children.text.strip.gsub("・"," ")).gsub(/[\u00A0]/, '')
    str = convert_date(str)
    return if city.css("a").length > 0
    return if /^[あ-ん]$/ =~ str
    return if str.empty?
    return if str =~ /^\d+$/
    return if /^[ごみカレンダー]/ =~ str
    if str.start_with?("資源") | str.start_with?("小型破砕")
      print str+"\t"
    elsif str == "可燃"
      print "センター\t"+str
    else
      print str
    end
  }

  print "\t"
end



html = Nokogiri::HTML(open('http://www.city.tottori.lg.jp/www/contents/1357776059978/index.html'))
label_count = c = dup_count = 0
html.xpath("//table").each{|table|
  c += 1
  next if c != 2
  table.css("tr").each { |tr|
    # puts tr
    label_flg = tr.css("td").css("p").children.text.start_with?("町名")
    next if label_count > 0 && label_flg
    label_count += 1 if  label_flg
    dup_count = 0
    tr.css("td").each { |td|
      l = 1
      l = 3 if dup_count == 4 && !label_flg
      print "\t" if dup_count == 2 && !label_flg
      for i in 1..l
        # p dup_count
        span = td.css("span")
        if span.length > 0
          export(span)
        else
          export(td.css("p"))
        end
      end
      dup_count += 1
    }
    puts
  }
}
