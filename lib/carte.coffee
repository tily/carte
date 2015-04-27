gulp = require 'gulp'
gulpUtil = require 'gulp-util'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'

class Carte
  build: (watch)->
    browserify = browserify
      cache: {}
      packageCache: {}
      fullPaths: true
      entries: ['./public/coffeescripts/app.coffee']
      extensions: ['.coffee', '.js', '.cjsx']
    browserify
      .transform 'coffee-reactify'
      .transform 'debowerify'
    if watch
      watchified = watchify(browserify)
      watchified.on 'update', ()=> @bundle(browserify)
      watchified.on 'log', gulpUtil.log
    @bundle(browserify)
  
  bundle: (browserify)->
    browserify
      .bundle()
      .pipe source 'app.js'
      .pipe gulp.dest 'public/javascripts'
