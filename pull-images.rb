require 'sequel'
require './models/image.rb'
require './models/flickr.rb'
require './models/config.rb'

h = Hash.new
while true do
  Flickr.index_images
  puts Image.all.count
end
