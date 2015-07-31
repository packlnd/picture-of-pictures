Dir.glob('models/*.rb').each do |model|
  require_relative model
end

Dir.glob('app/*.rb').each do |app|
  require_relative app
end
