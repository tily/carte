require 'sinatra/base'
require 'json'

module Carte
  class Server < Sinatra::Base
    VERSION = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../../../package.json")))['version']
  end
end
