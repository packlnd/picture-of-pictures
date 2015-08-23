require './models/database.rb'
require './models/flickr.rb'
require './models/image.rb'

h = Hash.new
while true do
  Flickr.index_images
  puts Image.all.count
end
