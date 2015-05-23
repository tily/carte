Backbone = require('backbone')
CardHistoryModel = require('./card_history')
$ = require('jquery')
config = require('../config')

module.exports = class CardHistories extends Backbone.Collection
  collectionName: 'CardHistories'

  model: CardHistoryModel

  query: {}

  url: ()->
    url = '/cards/' + @title + '/history.json'
    config.root_path + config.api_path + url

  parse: (response)->
    @pagination = response.pagination
    response.history
