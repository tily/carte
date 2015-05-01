require 'carte/server'
require 'json'

class Carte::Server
  configure do
    Mongoid.load! './mongoid.yml'
    config = JSON.parse File.read('config.json')
    set :carte, config
  end
end

run Carte::Server.new
