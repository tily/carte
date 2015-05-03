Backbone = require('backbone')
module.exports =
  reload: ()->
    Backbone.history.loadUrl()

  isMobile: ()->
    /(iPhone|iPod|iPad).*AppleWebKit/i.test(navigator.userAgent)
