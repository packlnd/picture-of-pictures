require 'rmagick'
require 'shade'
require 'open-uri'
require 'colorscore'

class Image < Sequel::Model

  def self.dominant_color(url)
    hg = Colorscore::Histogram.new(url)
    s,hc = hg.scores.first
    if hc.nil? then return 0.0,'#' end
    return s,hc.html.upcase
  end

  def self.insert_in_db(url, color)
    if Image.where(color: color).any?
      return
    end
    img = Image.new
    img.url=url
    img.color=color
    img.save
  end

  def self.do_pop_row(pop)
    1.upto(pop.inc) { |y|
      il = Magick::ImageList.new
      1.upto(pop.col) { |x|
        hex_color = get_hex_color(x-1,pop.y+(y-1),pop.img)
        if (h_img=pop.get_cache(hex_color)) == nil
          tmp = get_flickr_url(hex_color).first.scale(pop.size)
          pop.cache hex_color, tmp
          il.push(tmp)
        else
          il.push(h_img)
        end
      }
      pop.add_il il
    }
    pop.increment
    pop.write_to_file
    if pop.done? then pop.finalize end
    pop.fname
  end

  def self.get_flickr_url(hex_color)
    img = Image[color: hex_color]
    unless img == nil
      url = img[:url]
      return Magick::Image.from_blob(open(url).read)
    end
    get_similar hex_color
  end

  def self.get_similar(hc)
    get_flickr_url P.nearest_value(hc).color.html.upcase
  end

  def self.to_hex(px)
    r8b = px.red & 255
    g8b = px.green & 255
    b8b = px.blue & 255
    sprintf("#%02X%02X%02X", r8b, g8b, b8b)
  end

  def self.get_hex_color(x,y,img)
    px = img.pixel_color(x,y)
    to_hex(px)
  end

  def self.get_coverage
    sprintf("%.2f", (100*Image.count/(256.0*256*256)))
  end
end

P = Shade::Palette.new
Image.map(:color).each do |c|
  P.add(c)
end
