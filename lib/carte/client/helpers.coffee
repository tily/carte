Backbone = require('backbone')
module.exports =
  reload: ()->
    Backbone.history.loadUrl()

  isMobile: ()->
    /(iPhone|iPod|iPad).*AppleWebKit/i.test(navigator.userAgent)

  parseCardLink: (html)->
    html.replace /\[\[(.+?)\]\]/g, (match, p1)->
      if p1.match /<("[^"]*"|'[^']*'|[^'">])*>/g
        match
      else
        ['<a href="#/', encodeURIComponent(p1), '">', p1, '</a>'].join('')
