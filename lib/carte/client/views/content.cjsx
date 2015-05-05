# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
List = require('./list')
CardCollection = require('../models/cards')
CardModel = require('../models/card')
String = require('string')
config = require('../config')

module.exports = React.createClass
  displayName: 'Content'

  componentWillMount: ->
    console.log 'componentWillMount'
    @callback = ()=> @forceUpdate()
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
        cards.query = $.extend {}, config.default_query, @props.router.query
        cards.fetching = true
        cards.fetch success: ()-> cards.fetching = false
        title = []
        for k, v of cards.query
          if k != 'title'
            title.push(String(k).capitalize() + ': ' + v)
        title = title.join(', ')
        title = 'search: ' + cards.query.title + ' (' + title + ')' if cards.query.title
        title += ' - ' + config.title
        document.title = title
        <List key='list' router={@props.router} cards={cards} />
      when "show"
        console.log 'show'
        cards = new CardCollection()
        cards.fetching = true
        card = new CardModel(title: @props.router.title)
        card.fetch
          success: (card)->
            console.log card
            for left in card.get("lefts")
              cardModel = new CardModel(left)
              cardModel.set 'focused', false
              console.log 'adding left', cardModel
              cards.add cardModel
            card.set 'focused', true
            cards.add card
            for right in card.get("rights")
              cardModel = new CardModel(right)
              cardModel.set 'focused', false
              console.log 'adding right', cardModel
              cards.add cardModel
            cards.fetching = false
          error: (card, response)=>
            console.log 'error!!!!!!!!!!!!!!!!!!!!!!!!', response
            cards.fetching = false
        document.title = card.get('title') + ' - ' + config.title
        <List key='show' cards={cards} card={card} />
      else
        console.log 'else'
        <div>Loading ...</div>
