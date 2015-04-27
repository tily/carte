# @cjsx React.DOM 
React = require('react')
Card = require('./card.cjsx')

module.exports = React.createClass
  displayName: 'Cards'

  componentDidMount: ()->
    @props.cards.on 'add remove change', @forceUpdate.bind(@, null)
    @props.cards.on 'add', (model)->
      console.log 'add', model 

  render: ->
    console.log 'render cards'
    if @props.cards.length > 0
      console.log 'cards loaded'
      cards = @props.cards.map (card)-> <Card key={card.get("title")} card={card} />
      <div className='row'>{cards}</div>
    else
      console.log 'cards loading'
      <div>Loading ...</div>
