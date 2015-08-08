module App
  class Main < Sinatra::Application
    get '/' do
      @photos = Flickr.get_images
      haml :index
    end

    get '/coverage' do
      Image.get_coverage
    end

    get '/index' do
      Flickr.index_images
      Image.get_coverage
    end

    get '/pop' do
      Image.create_pop(params[:url])
    end
  end
end
