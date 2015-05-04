fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gulpUtil = require 'gulp-util'
gulpIf = require 'gulp-if'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'

module.exports = class Carte
  install: (gulp, config)->
    gulp.task 'build', =>
      @build
        watch: false
        minify: true
        config: config
    gulp.task 'watch', =>
      @build
        watch: true
        minifty: false
        config: config

  build: (options)->
    config = require(options.config)
    fs.writeFileSync(__dirname + '/carte/shared/config.json', JSON.stringify(config))
    dir = path.dirname config.script_path
    file = path.basename config.script_path
    minify = options.minify
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
      watchified.on 'update', ()=> @bundle(browserify, dir, file, minify)
      watchified.on 'log', gulpUtil.log
    @bundle(browserify, dir, file, minify)
  
  bundle: (browserify, dir, file, minify)->
    browserify
      .bundle()
      .pipe source file
      .pipe gulpIf(minify, streamify(uglify()))
      .pipe gulp.dest dir
