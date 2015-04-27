Backbone = require('backbone')

module.exports = class Word extends Backbone.Model
  url: ()->
    '/api/v1/words/' + @get('name') + '.json'
  parse: (response)->
    if response.word then response.word else response
