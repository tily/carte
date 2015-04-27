gulp = require 'gulp'
Carte = require './lib/carte'
path = 'public/javascripts/app.js'

carte = new Carte()

gulp.task 'build', ->
  carte.build watch: false, path: path

gulp.task 'watch', ->
  carte.build watch: true, path: path
