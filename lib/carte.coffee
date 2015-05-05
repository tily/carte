fs = require 'fs-extra'
path = require 'path'
gulp = require 'gulp'
gulpUtil = require 'gulp-util'
gulpIf = require 'gulp-if'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
_ = require 'lodash'

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
    fs.writeFileSync(__dirname + '/carte/shared/custom.json', JSON.stringify(config))
    dir = path.dirname config.script_path
    file = path.basename config.script_path
    minify = options.minify
    browserify = browserify
      cache: {}
      packageCache: {}
      fullPaths: true
      entries: [__dirname + '/carte/client.coffee']
      extensions: ['.coffee', '.js', '.cjsx', '.css']
    browserify
      .transform 'coffee-reactify'
      .transform 'debowerify'
      .transform 'browserify-css',
        rootDir: 'public'
        processRelativeUrl: (relativeUrl)->
          stripQueryStringAndHashFromPath = (url)-> url.split('?')[0].split('#')[0]
          rootDir = path.resolve(process.cwd(), 'public')
          relativePath = stripQueryStringAndHashFromPath(relativeUrl)
          queryStringAndHash = relativeUrl.substring(relativePath.length)
          prefix = '../node_modules/'
          if (_.startsWith(relativePath, prefix))
            vendorPath = 'vendor/' + relativePath.substring(prefix.length)
            source = path.join(rootDir, relativePath)
            target = path.join(rootDir, vendorPath)
            gulpUtil.log('Copying file from ' + JSON.stringify(source) + ' to ' + JSON.stringify(target))
            fs.copySync(source, target)
            return vendorPath + queryStringAndHash
          relativeUrl
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
