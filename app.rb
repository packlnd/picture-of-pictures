require 'sinatra'
require 'haml'
require 'sequel'
require 'rmagick'
require 'prizm'
require 'open-uri'
require 'set'
require 'shade'
require 'profiler'
Dir.glob('models/*.rb').each do |model|
  require_relative model
end

configure do
  @@pop = nil
end

get '/' do
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
  @@pop = Pop.new(params[:url])
  Image.do_pop_row @@pop
end

get '/continue_pop' do
  Image.do_pop_row @@pop
end
