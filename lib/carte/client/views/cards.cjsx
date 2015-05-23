# @cjsx React.DOM 
React = require('react')
Card = require('./card')
Message = require('./message')

module.exports = React.createClass
  displayName: 'Cards'

  getInitialState: ()->
    error: false

  componentDidMount: ()->
    console.log '[views/cards] component did mount'
    @props.cards.on 'sync', @forceUpdate.bind(@, null)
    if @props.card
      @props.card.on 'error', (model, response)=>
        @setState error: response
        @forceUpdate.bind(@, null)

  componentWillReceiveProps: (nextProps)->
    console.log '[views/cards] component will receive props'
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)
    if nextProps.card
      nextProps.card.on 'error', (model, response)=>
        @setState error: response
        @forceUpdate.bind(@, null)

  render: ->
    if @props.cards.fetching
      <Message>
        <i className='glyphicon glyphicon-refresh glyphicon-refresh-animate' /> Loading ...
      </Message>
    else if @state.error
      <Message>
        <i className='glyphicon glyphicon-alert' /> {@state.error.status} {@state.error.statusText}
      </Message>
    else
      cards = @props.cards.map (card)-> <Card key={card.get("title") + card.get("version")} card={card} />
      <div className='row'>{cards}</div>
