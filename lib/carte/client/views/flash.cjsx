# @cjsx React.DOM 
React = require('react')
OverlayMixin = require('react-bootstrap/lib/OverlayMixin')
FlashContent = React.createFactory require('./flash_content')

window.onerror = (error, url, line) -> alert error

module.exports = React.createClass
  displayName: 'Flash'
  mixins: [OverlayMixin]
  getDefaultProps: -> container: document.body
  renderOverlay: -> FlashContent(@props)
  render: -> null
