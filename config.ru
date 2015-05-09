require 'carte/server'
require 'json'

$config = JSON.parse(File.read('config.json'))

class Carte::Server
  configure do
    Mongoid.load! './mongoid.yml'
    set :carte, $config
  end
end

map('/') do
  use Rack::Deflater
  use Rack::Static, urls: [""], root: $config['root_dir'], index: $config['html_path']
  run Rack::Directory.new $config['root_dir']
end

map('/api') do
  run Carte::Server.new
end
