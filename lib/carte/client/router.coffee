querystring = require('querystring')
Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    ':title' : 'show'
    ''       : 'list'

  list: (string)->
    console.log '[router] list', string
    location.hash = '/' if location.hash == ''
    @current = 'list'
    @query = querystring.parse(string)

  show: (title)->
    console.log '[router] show', title
    @current = 'show'
    @title = title
