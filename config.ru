require 'carte/server'
Carte::Server.configure { Mongoid.load!('./mongoid.yml') }
map('/api') { run Carte::Server.new }
use Rack::Static, :urls => [""], :root => 'public', :index => 'index.html'
run Rack::Directory.new('public')
