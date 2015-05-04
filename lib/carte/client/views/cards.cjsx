# @cjsx React.DOM 
React = require('react')
Card = require('./card')

module.exports = React.createClass
  displayName: 'Cards'

  getInitialState: ()->
    error: false

  componentDidMount: ()->
    console.log 'component did mount'
    @props.cards.on 'sync', @forceUpdate.bind(@, null)
    @props.card.on 'sync', @forceUpdate.bind(@, null)
    @props.card.on 'error', (model, response)=>
      @setState error: response
      @forceUpdate.bind(@, null)

  render: ->
    console.log 'render cards', @props.cards, @state
    if @state.error
      <div className='row'>
        {
          for i in [1..9]
            <div className='col-sm-4' style={padding:'5px'} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
              <div className='list-group'style={margin:'0px',padding:'0px'}>
                <div className='list-group-item' style={height:'220px'}>
                  <i className='glyphicon glyphicon-alert' /> {@state.error.status} {@state.error.statusText}
                </div>
              </div>
            </div>
        }
      </div>
    else if !@props.cards.fetching
      console.log 'cards loaded'
      cards = @props.cards.map (card)-> <Card key={card.get("title")} card={card} />
      <div className='row'>{cards}</div>
    else
      console.log 'cards loading'
      <div className='row'>
        {
          for i in [1..9]
            <div className='col-sm-4' style={padding:'5px'} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
              <div className='list-group'style={margin:'0px',padding:'0px'}>
                <div className='list-group-item' style={height:'220px'}>
                  <i className='glyphicon glyphicon-refresh glyphicon-refresh-animate' /> Loading ...
                </div>
              </div>
            </div>
        }
      </div>
