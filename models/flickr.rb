require 'flickraw'
require 'colorscore'
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
        s,hc=Image.dominant_color(url)
        rescue Magick::ImageMagickError
          next
      end
      unless S.include? hc or s<0.33
        Image.insert_in_db(url, hc)
        S.add hc
      end
    end
  end

  def self.get_images
    FlickRaw.api_key=FlickrConfig.api_key
    FlickRaw.shared_secret=FlickrConfig.secret
    flickr.photos.getRecent
  end
end
