gulp = require 'gulp'
Carte = require './lib/carte'

carte = new Carte()
path = 'public/app.js'

gulp.task 'build', ->
  carte.build
    watch: false
    minify: true
    config: __dirname + '/config.json'

gulp.task 'watch', ->
  carte.build
    watch: true
    minifty: false
    config: __dirname + '/config.json'
