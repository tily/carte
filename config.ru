require 'carte/server'
use Rack::Static, :urls => [""], :root => 'public', :index => 'index.html'
Carte::Server.configure { Mongoid.load!('./mongoid.yml') }
map('/api') { run Carte::Server.new }
