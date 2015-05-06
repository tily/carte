fs = require 'fs-extra'
path = require 'path'
gulp = require 'gulp'
gulpUtil = require 'gulp-util'
gulpIf = require 'gulp-if'
sourceStream = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
_ = require 'lodash'
jade = require 'gulp-jade'
rename = require 'gulp-rename'

module.exports = class Carte
  watching: false

  install: (gulp, config)->
    custom = require(config)
    fs.writeFileSync(__dirname + '/carte/shared/custom.json', JSON.stringify(custom))

    gulp.task 'watching', => @watching = true
    gulp.task 'build', ['build:html', 'build:script']
    gulp.task 'watch', ['watching', 'build:html', 'build:script']

    gulp.task 'build:html', =>
      _config = require('./carte/client/config')
      gulp.src(__dirname + '/carte/client.jade')
        .pipe jade(locals: {config: _config}, pretty: true)
        .pipe rename(_config.html_path)
        .pipe gulp.dest(_config.root_dir)

    gulp.task 'build:script', =>
      @buildScript config: config

  buildScript: (options)->
    config = require(options.config)
    fs.writeFileSync(__dirname + '/carte/shared/custom.json', JSON.stringify(config))
    dir = config.root_dir
    file = path.basename config.script_path
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
    if @watching
      watchified = watchify(browserify)
      watchified.on 'update', ()=> @bundle(browserify, dir, file)
      watchified.on 'log', gulpUtil.log
    @bundle(browserify, dir, file)
  
  bundle: (browserify, dir, file)->
    browserify
      .bundle()
      .pipe sourceStream file
      .pipe gulpIf(!@watching, streamify(uglify()))
      .pipe gulp.dest dir
