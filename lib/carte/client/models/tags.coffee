Backbone = require('backbone')
Tag = require('./tag')
$ = require('jquery')
config = require('../config')

module.exports = class Tags extends Backbone.Collection
  collectionName: 'Tags'
  model: Tag
  url: config.root_path + config.api_path + '/tags.json'
  parse: (response)-> response.tags
