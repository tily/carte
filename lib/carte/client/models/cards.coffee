Backbone = require('backbone')
CardModel = require('./card')
$ = require('jquery')
config = require('../config')

module.exports = class Cards extends Backbone.Collection
  model: CardModel
  query: {}
  url: ()->
    url = '/cards.json?' + $.param(@query)
    config.root_path + config.api_path + url
  parse: (response)->
    console.log response
    @page = response.page
    console.log @page
    response.cards
