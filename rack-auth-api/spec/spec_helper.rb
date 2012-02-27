require 'rubygems'
require 'bundler'

Bundler.setup :default, :development, :test

require 'rack/test'
require 'rack/auth_api'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end


