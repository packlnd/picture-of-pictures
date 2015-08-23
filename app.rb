require 'sinatra'
require 'haml'
require './models/database.rb'
require './models/recent.rb'
require './models/image.rb'
require './models/pop.rb'

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

get '/all' do
  haml :all
end
