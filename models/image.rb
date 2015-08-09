require 'rubygems'
require 'prizm'
require 'sequel'
require 'rmagick'
require "open-uri"

DB = Sequel.connect('sqlite://db.db')
DB.create_table? :images do
  String :color, :null=>false, :unique=>true
  String :url, :null=>false
end

DEFAULT = Magick::Image.read("public/imgs/default.png")

class Image < Sequel::Model
  @@counter = 0.0
  def self.dominant_color(url)
    ext = Prizm::Extractor.new(url)
    pixel = ext.get_colors(1, false)[0]
    to_hex(pixel)
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

  def self.create_pop(url)
    @@counter = 0.0
    h = Hash.new
    img = Magick::ImageList.new
    img.from_blob(open(url).read)
    row = img.rows
    col = img.columns
    ilg = Magick::ImageList.new
    1.upto(col) { |y|
      il = Magick::ImageList.new
      1.upto(row) { |x|
        hex_color = get_hex_color(x,y,img)
        if (h_img=h[hex_color]) == nil
          tmp = get_flickr_url(hex_color).first.scale(0.06)
          h[hex_color] = tmp
          il.push(tmp)
        else
          il.push(h_img)
        end
      }
      ilg.push(il.append(false))
    }
    ilg.append(true).write("public/out.jpg")
    sprintf("%.2f%", 100*@@counter/(row*col))
  end

  def self.get_flickr_url(hex_color)
    img = Image[color: hex_color]
    unless img == nil
      url = img[:url]
      @@counter = @@counter+1
      return Magick::Image.from_blob(open(url).read)
    end
    DEFAULT
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
