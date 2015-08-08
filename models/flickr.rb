require 'flickraw'

class Flickr
  def self.index_images
    photos = get_images
    photos.each do |photo|
      url = FlickRaw.url_q(photo)
      puts url
      begin
        hex_string = Image.dominant_color(url)
        rescue Magick::ImageMagickError
          next
      end
      Image.insert_in_db(url, hex_string)
    end
    puts "done"
  end

  def self.get_images
    FlickRaw.api_key=FlickrConfig.api_key
    FlickRaw.shared_secret=FlickrConfig.secret
    flickr.photos.getRecent
  end
end
