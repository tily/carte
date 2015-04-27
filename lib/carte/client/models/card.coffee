Backbone = require('backbone')

module.exports = class Card extends Backbone.Model
  url: ()->
    '/api/cards/' + @get('title') + '.json'
  parse: (response)->
    if response.card then response.card else response
