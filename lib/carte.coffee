fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gulpUtil = require 'gulp-util'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'

module.exports = class Carte
  build: (options)->
    config = require(options.config)
    fs.writeFileSync(__dirname + '/carte/shared/config.json', JSON.stringify(config))
    dir = path.dirname config.script_path
    file = path.basename config.script_path
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
