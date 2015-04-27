path = require 'path'
gulp = require 'gulp'
gulpUtil = require 'gulp-util'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'

module.exports = class Carte
  build: (options)->
    dir = path.dirname options.path
    file = path.basename options.path
    console.log dir, file
    browserify = browserify
      cache: {}
      packageCache: {}
      fullPaths: true
      entries: [__dirname + '/carte/client.coffee']
      extensions: ['.coffee', '.js', '.cjsx']
    browserify
      .transform 'coffee-reactify'
      .transform 'debowerify'
    if options.watch
      watchified = watchify(browserify)
      watchified.on 'update', ()=> @bundle(browserify, dir, file)
      watchified.on 'log', gulpUtil.log
    @bundle(browserify, dir, file)
  
  bundle: (browserify, dir, file)->
    browserify
      .bundle()
      .pipe source file
      .pipe gulp.dest dir
