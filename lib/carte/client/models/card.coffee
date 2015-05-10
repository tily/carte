Backbone = require('backbone')
config = require('../config')
querystring = require('querystring')

module.exports = class Card extends Backbone.Model
  idAttribute: 'title'

  isNew: ()->
    @_isNew

  url: ()->
    if @isNew()
      url = '/cards.json'
    else
      url = '/cards/' + encodeURIComponent(@get('title')) + '.json'
    config.root_path + config.api_path + url

  parse: (response)->
    if response.card then response.card else response
