#威锋网
#coding: utf-8
require './lib/crawler/base'

def filter_content(body)
  if body
    igs = body.search("ignore_js_op")
    igs.remove
    scripts = body.search("script")
    scripts.remove
  end
  body.try(:content).try(:strip)
end

def fetch_body(url)
  doc = Nokogiri::HTML(open(url))
  body = doc.css('div.t_fsz').first
end

def handle_img_link(entry, url)
  html = fetch_body(url).inner_html

  Nokogiri::HTML(html).css('img').each do |img|
    next unless img.attributes["file"]
    puts img.attributes["file"]
    name = download_img(img.attributes["file"], (SecureRandom.hex 4))
    save_img(entry, name, img.attributes["file"])
  end
end

def has_img(body)
  html = body.inner_html
  Nokogiri::HTML(html).css('img').size > 0 ? true : false
end

def save_img(entry, name, origin_link)
  entry.images.create!(
    img_origin_link: origin_link.to_s,
    img_link: "/pd_images/#{name}",
    img_name: name,
    source: "feng"
  )
end

def download_img(link, name)
  puts link
  File.open("./public/pd_images/#{name}.jpg", 'wb') do |f|
    f.write open(link, :read_timeout => 600).read
  end
  "#{name}.jpg"
end

happend_at = ""
1.upto(1) do |i|
  url = "http://bbs.feng.com/forum.php?mod=forumdisplay&fid=29&orderby=dateline&filter=author&orderby=dateline&page=#{i}"
  linksdoc = Nokogiri::HTML(open(url).read)
  linksdoc.css('table#threadlisttableid tbody').each do |pd|
    next if pd.css('tr th.new').blank?
    name = pd.css('tr th.new a.xst').first.content

    happend_at = pd.css('tr td.by span.xi1 span').first.try(:content) || ""
    break if happend_at.blank? or happend_at.include? "昨天"

    user = pd.css('tr td.by a').first.try(:content)
    pd_link = "http://bbs.feng.com/" + pd.css('tr th.new a.xst').first.attributes["href"].value

    body = fetch_body(pd_link)
    puts body
    next unless has_img(body)
    
    content = filter_content(body)

    puts "--------------------------------------------------------------------------------"
    puts "name: " + name
    puts "product link: " + pd_link
    puts "user: " + user
    puts "happend_at: " + happend_at
    puts "content: " + content unless content.blank?

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      entry.name= name
      entry.user= user
      entry.source = "feng"
      entry.happend_at = Time.new
      entry.content = content
      entry.save

      handle_img_link(entry, pd_link)
      update_entry_img(entry)
    end
  end

  break if happend_at.blank? or happend_at.include? "昨天"
end
