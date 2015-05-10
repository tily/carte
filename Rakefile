require "bundler/gem_tasks"
require "carte/server/tasks"
Carte::Server.configure { Mongoid.load!('mongoid.yml') }
task(:default) { exit 0 }
