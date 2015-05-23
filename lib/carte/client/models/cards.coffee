Backbone = require('backbone')
CardModel = require('./card')
$ = require('jquery')
config = require('../config')

module.exports = class Cards extends Backbone.Collection
  collectionName: 'Cards'

  model: CardModel
  query: {}
  url: ()->
    url = '/cards.json?' + $.param(@query)
    config.root_path + config.api_path + url
  parse: (response)->
    @pagination = response.pagination
    response.cards
