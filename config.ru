require 'carte/server'
require 'json'

class Carte::Server
  configure do
    Mongoid.load! './mongoid.yml'
    set :carte, JSON.parse(File.read('config.json'))
  end
end

run Carte::Server.new
