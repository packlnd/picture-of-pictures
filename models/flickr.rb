require 'flickraw'

class Flickr
  def self.index_images
    puts "Indexing images"
    photos = get_images
    photos.each do |photo|
      url = construct_url(photo)
      hex_string = Image.dominant_color(url)
      Image.insert_in_db(url, hex_string)
    end
  end

  def self.get_images
    FlickRaw.api_key=FlickrConfig.api_key
    FlickRaw.shared_secret=FlickrConfig.secret
    flickr.photos.getRecent
  end

  def self.construct_url(photo)
    'https://farm' + photo.farm.to_s + '.staticflickr.com/' +
      photo.server.to_s + '/' + photo.id.to_s + '_' + photo.secret.to_s + '_q.jpg'
  end
end
