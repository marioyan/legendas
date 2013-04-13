require "rubygems"
require "bundler"

Bundler.require

require "./subtitle"
require "./api"
require "./app"

run Sinatra::Application
