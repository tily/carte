Backbone = require('backbone')

module.exports = class Card extends Backbone.Model
  idAttribute: 'title'

  isNew: ()->
    @_isNew

  url: ()->
    if @isNew()
      console.log @
      console.log 'url is new'
      '/api/cards.json'
    else
      console.log 'url is not new'
      '/api/cards/' + @get('title') + '.json'

  parse: (response)->
    if response.card then response.card else response
