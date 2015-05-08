# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json'

Gem::Specification.new do |spec|
  spec.name          = "carte-server"
  spec.version       = JSON.parse(File.read("./package.json"))['version']
  spec.authors       = ["tily"]
  spec.email         = ["tidnlyam@gmail.com"]
  spec.summary       = %q{something like dictionary, wiki, or information card}
  spec.description   = %q{something like dictionary, wiki, or information card}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "shotgun"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "httparty"
  
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "mongoid"
  spec.add_dependency "mongoid_auto_increment_id", "0.6.5"
  spec.add_dependency "will_paginate_mongoid"
  spec.add_dependency "activesupport"
  spec.add_dependency "haml"
  spec.add_dependency "mongoid-simple-tags"
  spec.add_dependency "mongoid-geospatial"
  spec.add_dependency "redcarpet"
end
