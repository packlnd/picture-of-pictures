require 'sinatra'
require 'haml'
require 'sequel'
require 'rmagick'
require 'prizm'
require 'open-uri'
require 'set'
require File.dirname(__FILE__) + '/boot.rb'

run App::Main
