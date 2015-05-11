# @cjsx React.DOM 
React = require('react')
Card = require('./card')

module.exports = React.createClass
  displayName: 'Message'

  render: ->
    <div className='row'>
      {
        for i in [1..9]
          <div key={i} className='col-sm-4' style={padding:'5px'} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
            <div className='list-group'style={margin:'0px',padding:'0px'}>
              <div className='list-group-item' style={height:'200px'}>
                {@props.children}
              </div>
            </div>
          </div>
      }
    </div>
