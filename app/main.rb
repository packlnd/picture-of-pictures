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
    end

    get '/pop' do
      @pop = Image.create_pop(params[:url])
      redirect '/pap'
    end

    get '/pap' do
      @pop = [[],[]]
      haml :pop
    end
  end
end
