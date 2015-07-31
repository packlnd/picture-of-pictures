module App
  class Main < Sinatra::Application
    get '/' do
      @photos = Flickr.get_images
      haml :index
    end
  end
end
