require 'carte/server'
require 'rack/gzip_static'
require 'json'

$config = JSON.parse(File.read('config.json'))

class Carte::Server
  configure do
    Mongoid.load! './mongoid.yml'
    set :carte, $config
  end
end

map('/') do
  use Rack::GzipStatic, urls: [""], root: $config['root_dir'], index: $config['html_path']
  run lambda {}
end

map('/api') do
  run Carte::Server.new
end
