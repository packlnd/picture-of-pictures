require 'sinatra'
require 'haml'
require 'sequel'
require 'rmagick'
require 'prizm'
require 'open-uri'
require 'set'
require 'shade'
require 'profiler'
require './models/database.rb'
Dir.glob('models/*.rb').each do |model|
  require_relative model
end

configure do
  @@pop = nil
end

get '/' do
  @recent = Recent.all
  haml :index
end

get '/coverage' do
  Image.get_coverage
end

get '/begin_pop' do
  @@pop = Pop.new(params[:url], params[:inc].to_i, params[:size])
  Image.do_pop_row @@pop
end

get '/continue_pop' do
  Image.do_pop_row @@pop
end
