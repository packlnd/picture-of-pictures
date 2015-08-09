require 'flickraw'
require 'set'

S = Set.new

class Flickr
  def self.index_images
    photos = get_images
    photos.each do |photo|
      url = FlickRaw.url_q(photo)
      if S.include? url then next end
      S.add url
      begin
        hex_string = Image.dominant_color(url)
        rescue Magick::ImageMagickError
          next
      end
      unless S.include? hex_string
        Image.insert_in_db(url, hex_string)
        S.add hex_string
      end
    end
  end

  def self.get_images
    FlickRaw.api_key=FlickrConfig.api_key
    FlickRaw.shared_secret=FlickrConfig.secret
    flickr.photos.getRecent
  end
end
