Backbone = require('backbone')
CardModel = require('./card')
$ = require('jquery')

module.exports = class Cards extends Backbone.Collection
  model: CardModel
  query: {}
  url: ()->
      '/api/cards.json?' + $.param(@query)
  parse: (response)->
    console.log response
    response.cards
