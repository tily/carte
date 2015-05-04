gulp = require 'gulp'
Carte = require './lib/carte'
new Carte().install(gulp, __dirname + '/config.json')
