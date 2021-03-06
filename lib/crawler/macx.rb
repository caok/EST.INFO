#www.macx.cn
#encoding: utf-8
require './lib/crawler/base'

def filter_content(body)
  if body
    igs = body.search("ignore_js_op")
    igs.remove
    scripts = body.search("script")
    scripts.remove
    status = body.search("i.pstatus")
    status.remove
  end
  body.try(:content).try(:strip)
end

def handle_img_link(entry, doc)
  html = fetch_body(doc, "div.v2-t_fsz").inner_html

  Nokogiri::HTML(html).css('img').each do |img|
    next unless img.attributes["file"]
    name = download_img(img.attributes["file"], (SecureRandom.hex 4))
    save_img(entry, name, img.attributes["file"])
  end
end

def save_img(entry, name, origin_link)
  entry.images.create!(
    img_origin_link: origin_link.to_s,
    img_link: "/pd_images/#{name}",
    img_name: name,
    source: "macx"
  )
end

def download_img(link, name)
  File.open("./public/pd_images/#{name}.jpg", 'wb') do |f|
    f.write open(link, :read_timeout => 600).read
  end
  "#{name}.jpg"
rescue => e
  puts "download_img error: #{e}"
  return
end

count = 0
happend_at = ""
url = "http://www.macx.cn/forum.php?mod=forumdisplay&fid=10001&orderby=dateline&filter=dateline&dateline=86400&orderby=dateline&sortid=3"

linksdoc = Nokogiri::HTML(open(url).read)

linksdoc.css('div.bm_c ul.ml li').each_with_index do |pd, index|
  begin
    name = pd.css('h3.ptn a').first.content
    next if name.include? "[置顶]"

    happend_at = pd.css('div.cl').last.css('em.xs0').last.content
    next if happend_at != Date.today.strftime('%y-%m-%d').gsub("-0", "-")

    pd_link = pd.css('h3.ptn a').first.attributes["href"].value
    doc = get_doc(pd_link)

    body = fetch_body(doc.dup, "div.typeoption")
    sketch = filter_content(body) 
    city = sketch.match(/地区:\r\n.*\r\n/).to_s.delete("地区:").try(:strip)
    price = sketch.match(/出售价格:\r\n.*\r\n/).to_s.delete("出售价格:").try(:strip)

    body = fetch_body(doc.dup, "div.v2-t_fsz")
    next unless has_imgs?(body)
    content = filter_content(body)

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.delay(run_at: (index*30).seconds.from_now, queue: "twitter").tweet(name, price, pd_link)
      entry.name= name
      entry.source = "macx"
      entry.happend_at = Time.new
      entry.content = content
      entry.city = city unless city.blank?
      entry.price = price unless price.blank?
      entry.save

      handle_img_link(entry, doc.dup)
      update_entry_img(entry)
      entry.delay(queue: "image").upload_to_qiniu
      count += 1
    end
  rescue => e
    puts "macx: #{e}"
    next
  end
end

puts "Add #{count} entries from macx at #{Time.new}."
