gulp = require 'gulp'
Tasks = require('./lib/carte').Tasks
(new Tasks).install(gulp, __dirname + '/config.json')
