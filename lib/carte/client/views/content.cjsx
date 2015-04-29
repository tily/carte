# @cjsx React.DOM 
React = require('react')
List = require('./list')
CardCollection = require('../models/cards')
CardModel = require('../models/card')

module.exports = React.createClass
  displayName: 'Content'

  componentWillMount: ->
    console.log 'componentWillMount'
    @callback = ()=> console.log @; @forceUpdate()
    @props.router.on "route", @callback

  componentWillUnmount: ->
    console.log 'componentWillMount un'
    @props.router.off "route", @callback

  render: ->
    console.log 'render component'
    switch @props.router.current
      when "list"
        console.log 'list', @props.router.query
        cards = new CardCollection()
        cards.query = @props.router.query
        cards.query.sort = 'title' if !cards.query.sort
        cards.query.order = 'asc' if !cards.query.order
        cards.fetch()
        <List key='list' cards={cards} showNav=true />
      when "show"
        console.log 'show'
        cards = new CardCollection()
        card = new CardModel(title: @props.router.title)
        card.fetch
          success: (card)->
            console.log card
            for l in card.get("lefts")
              cardModel = new CardModel(l)
              cardModel.set 'focused', false
              console.log 'adding l', cardModel
              cards.add cardModel
            card.set 'focused', true
            cards.add card
            for r in card.get("rights")
              cardModel = new CardModel(r)
              cardModel.set 'focused', false
              console.log 'adding r', cardModel
              cards.add cardModel
        <List key='show' cards={cards} showNav=false />
      else
        console.log 'else'
        <div>Loading ...</div>
