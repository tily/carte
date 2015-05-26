Backbone = require('backbone')
config = require('../config')
querystring = require('querystring')
$ = require('jquery')

module.exports = class Tag extends Backbone.Model
  modelName: 'Tag'
  idAttribute: 'name'
  url: ()-> config.root_path + config.api_path + '/tags/' + encodeURIComponent(@get('name')) + '.json'
