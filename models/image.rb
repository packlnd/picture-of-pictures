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

class Image < Sequel::Model
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
    img = Magick::ImageList.new
    img.from_blob(open(url).read)
    row = img.rows
    col = img.columns
    ilg = Magick::ImageList.new
    1.upto(col) { |x|
      il = Magick::ImageList.new
      1.upto(row) { |y|
        hex_color = get_hex_color(x,y,img)
        tmp = get_flickr_url(hex_color)
        il.push(tmp.first.scale(0.04))
      }
      ilg.push(il.append(false))
    }
    ilg.append(true).write("public/out.jpg")
    "out.jpg"
  end

  def self.get_flickr_url(hex_color)
    img = Image.where(color: hex_color)
    if img.empty?
      Magick::Image.read("public/imgs/default.png")
    else
      Magick::Image.from_blob(open(img.map(:url)[0]).read)
    end
  end

  def self.to_hex(px)
    r8b = px.red & 255
    g8b = px.green & 255
    b8b = px.blue & 255
    "#%02X%02X%02X" % [r8b, g8b, b8b]
  end

  def self.get_hex_color(x,y,img)
    px = img.pixel_color(x,y)
    to_hex(px)
  end

  def self.get_coverage
    (100*Image.count/(256*256*256)).to_s
  end
end
