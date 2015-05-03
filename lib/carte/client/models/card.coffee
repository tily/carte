Backbone = require('backbone')
config = require('../../shared/config.json')

module.exports = class Card extends Backbone.Model
  idAttribute: 'title'

  isNew: ()->
    @_isNew

  url: ()->
    if @isNew()
      console.log @
      console.log 'url is new'
      url = '/api/cards.json'
    else
      console.log 'url is not new'
      url = '/api/cards/' + @get('title') + '.json'
    if config.api_path
      url = config.api_path + url
    url

  parse: (response)->
    if response.card then response.card else response
