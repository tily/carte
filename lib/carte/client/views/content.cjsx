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
    console.log '[views/content] component will mount'
    @callback = ()=> @forceUpdate()
    @props.router.on "route", @callback

  componentWillUnmount: ->
    console.log '[views/content] component will unmount'
    @props.router.off "route", @callback

  render: ->
    <div className="carte-content">
      {
        switch @props.router.current
          when "list"
            cards = new CardCollection()
            cards.query = $.extend {}, config.default_query, @props.router.query
            cards.fetching = true
            cards.fetch success: ()-> cards.fetching = false
            #title = []
            #for k, v of cards.query
            #  title.push(String(k).capitalize() + ': ' + v)
            #title = title.join(', ')
            #title = config.title + ' (' + title + ')'
            #document.title = title
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
          when "slideshow"
            console.log 'slideshow', @props.router.query
            cards = new CardCollection()
            cards.query = $.extend {}, config.default_query, @props.router.query
            cards.fetching = true
            cards.fetch success: ()-> cards.fetching = false
            document.title = config.title + '、スライドショー'
            e = React.createElement(Slideshow, cards: cards)
            React.render(e, document.body)
            #<Slideshow key='slideshow' router={@props.router} cards={cards} />
          else
            <div>Loading ...</div>
      }
    </div>
