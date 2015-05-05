# @cjsx React.DOM 
React = require('react')
Card = require('./card')
Message = require('./message')

module.exports = React.createClass
  displayName: 'Cards'

  getInitialState: ()->
    error: false

  componentDidMount: ()->
    console.log 'component did mount'
    @props.cards.on 'sync', @forceUpdate.bind(@, null)
    if @props.card
      @props.card.on 'error', (model, response)=>
        @setState error: response
        @forceUpdate.bind(@, null)

  componentWillReceiveProps: (nextProps)->
    console.log 'component did mount'
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)
    if nextProps.card
      nextProps.card.on 'error', (model, response)=>
        @setState error: response
        @forceUpdate.bind(@, null)

  render: ->
    console.log 'render cards', @props.cards, @state
    if @props.cards.fetching
      console.log 'cards loading'
      <Message>
        <i className='glyphicon glyphicon-refresh glyphicon-refresh-animate' /> Loading ...
      </Message>
    else if @state.error
      <Message>
        <i className='glyphicon glyphicon-alert' /> {@state.error.status} {@state.error.statusText}
      </Message>
    else
      console.log 'cards loaded'
      cards = @props.cards.map (card)-> <Card key={card.get("title")} card={card} />
      <div className='row'>{cards}</div>
