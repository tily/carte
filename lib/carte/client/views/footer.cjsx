# @cjsx React.DOM 
React = require('react')

module.exports = React.createClass
  displayName: 'Footer'

  render: ->
    <div style={{paddingTop:'0px',paddingBottom:'100px',paddingRight:"30px",paddingLeft:'30px'}}>
      <span className="pull-right">
        powered by <a href="https://github.com/tily/carte">carte</a>
      </span>
    </div>
