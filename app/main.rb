require 'profiler'

module App
  class Main < Sinatra::Application
    before do
      @pop = nil
    end

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

    get '/begin_pop' do
      @pop = Pop.new(params[:url])
      puts @pop.col.to_s
      Image.do_row @pop
    end

    get '/continue_pop' do
      puts @pop.col.to_s
      Image.do_row @pop
    end
  end
end
