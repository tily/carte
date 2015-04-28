require 'carte/server'
require 'json'

class Carte::Server
  configure do
    Mongoid.load! './mongoid.yml'
    config = JSON.parse File.read('config.json')
    config.each do |k, v|
      set k.to_sym, v
    end
  end
end

run Carte::Server.new
