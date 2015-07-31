require 'flickraw'

class Flickr
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
