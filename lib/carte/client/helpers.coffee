
module.exports =
  isMobile: ()->
    /(iPhone|iPod|iPad).*AppleWebKit/i.test(navigator.userAgent)
