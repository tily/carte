# @cjsx React.DOM 
React = require('react')
Card = require('./card.cjsx')

module.exports = React.createClass
  displayName: 'Cards'

  componentDidMount: ()->
    console.log 'component did mount'
    @props.cards.on 'add remove change', @forceUpdate.bind(@, null)
    @props.cards.on 'add', (model)->
      console.log 'add', model 

  componentWillReceiveProps: (nextProps)->
    console.log 'component will receive props'
    nextProps.cards.on 'add remove change', @forceUpdate.bind(@, null)
    nextProps.cards.on 'add', (model)->
      console.log 'add', model 

  render: ->
    console.log 'render cards'
    if @props.cards.length > 0
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
