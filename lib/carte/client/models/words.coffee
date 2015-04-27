Backbone = require('backbone')
WordModel = require('./word')
$ = require('jquery')

module.exports = class Words extends Backbone.Collection
  model: WordModel
  query: {}
  url: ()->
      '/api/v1/words.json?' + $.param(@query)
  parse: (response)->
    console.log response
    response.words
