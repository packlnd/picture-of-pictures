require 'rubygems'
require 'prizm'
require 'sequel'

DB = Sequel.connect('sqlite://db.db')
DB.create_table? :images do
  String :color, :null=>false, :unique=>true
  String :url, :null=>false
end

class Image < Sequel::Model
  def self.dominant_color(url)
    ext = Prizm::Extractor.new(url)
    colors = ext.get_colors(1, false)[0]
    ext.to_hex(colors)
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
    Array.new(150) {Array.new(150,url)}
  end

  def self.get_coverage
    (100*Image.count/(256*256*256)).to_s
  end
end
