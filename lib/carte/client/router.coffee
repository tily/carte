querystring = require('querystring')
Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    '': 'list'
    ':title': 'show'
    ':title/history': 'history'

  list: (string)->
    console.log '[router] list', string
    location.hash = '/' if location.hash == ''
    @current = 'list'
    @query = querystring.parse(string)

  show: (title, string)->
    console.log '[router] show', title
    @current = 'show'
    @title = title
    @query = querystring.parse(string)

  history: (title)->
    console.log '[router] history', title
    @current = 'history'
    @title = title
