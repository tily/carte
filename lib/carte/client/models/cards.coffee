Backbone = require('backbone')
CardModel = require('./card')
$ = require('jquery')
config = require('../../shared/config.json')

module.exports = class Cards extends Backbone.Collection
  model: CardModel
  query: {}
  url: ()->
    url = '/api/cards.json?' + $.param(@query)
    if config.api_path
      url = config.api_path + url
    url
  parse: (response)->
    console.log response
    @page = response.page
    console.log @page
    response.cards
