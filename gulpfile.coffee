gulp = require 'gulp'
Carte = require './lib/carte'

carte = new Carte()
path = 'public/javascripts/app.js'

gulp.task 'build', ->
  carte.build watch: false, path: path

gulp.task 'watch', ->
  carte.build watch: true, path: path
