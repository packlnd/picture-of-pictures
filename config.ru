require 'sinatra'
require 'haml'
require 'sequel'
require File.dirname(__FILE__) + '/boot.rb'

map "/" do
  run App::Main
end
