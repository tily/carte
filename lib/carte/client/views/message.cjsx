# @cjsx React.DOM 
React = require('react')
Card = require('./card')

module.exports = React.createClass
  displayName: 'Message'

  render: ->
    <div className='row'>
      {
        for i in [1..9]
          <div key={i} className='col-sm-4'>
            <div className='list-group'>
              <div className='list-group-item carte-card-height'>
                {@props.children}
              </div>
            </div>
          </div>
      }
    </div>
