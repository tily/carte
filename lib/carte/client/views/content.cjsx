# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
List = require('./list')
Slideshow = require('./slideshow')
CardCollection = require('../models/cards')
CardModel = require('../models/card')
String = require('string')
config = require('../config')

module.exports = React.createClass
  displayName: 'Content'

  componentWillMount: ->
    console.log '[views/content] component will mount'
    @callback = ()=> @forceUpdate()
    @props.router.on "route", @callback

  componentWillUnmount: ->
    console.log '[views/content] component will unmount'
    @props.router.off "route", @callback

  render: ->
    console.log '[views/content] render'
    <div className="carte-content">
      {
        switch @props.router.current
          when "list"
            console.log '[views/content] list', @props
            cards = new CardCollection()
            cards.query = $.extend {}, config.default_query, @props.router.query
            cards.fetching = true
            cards.fetch success: ()-> cards.fetching = false
            if cards.query.mode == 'flash'
              cards.query.auto = 'off' if !cards.query.auto
              cards.query.hide = 'none' if !cards.query.hide
              document.title = config.title + '、スライドショー'
              <Slideshow key='slideshow' router={@props.router} cards={cards} />
            else
              document.title = config.title
              <List key='list' router={@props.router} cards={cards} />
          when "show"
            cards = new CardCollection()
            cards.fetching = true
            card = new CardModel(title: @props.router.title)
            card.fetch
              success: (card)->
                for left in card.get("lefts")
                  cardModel = new CardModel(left)
                  cardModel.set 'focused', false
                  cards.add cardModel
                card.set 'focused', true
                cards.add card
                for right in card.get("rights")
                  cardModel = new CardModel(right)
                  cardModel.set 'focused', false
                  cards.add cardModel
                cards.fetching = false
              error: (card, response)=>
                cards.fetching = false
            document.title = config.title + '、' + card.get('title')
            <List key='show' cards={cards} card={card} />
          else
            null
      }
    </div>
