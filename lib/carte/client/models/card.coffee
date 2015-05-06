Backbone = require('backbone')
config = require('../config')
querystring = require('querystring')

module.exports = class Card extends Backbone.Model
  idAttribute: 'title'

  isNew: ()->
    @_isNew

  url: ()->
    if @isNew()
      console.log @
      console.log 'url is new'
      url = '/cards.json'
    else
      console.log 'url is not new'
      url = '/cards/' + encodeURIComponent(@get('title')) + '.json'
    config.root_path + config.api_path + url

  parse: (response)->
    if response.card then response.card else response
