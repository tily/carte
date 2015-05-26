querystring = require('querystring')
Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    'tags': 'tags'
    '': 'list'
    ':title': 'show'
    ':title/history': 'history'

  tags: ->
    console.log '[router] tags'
    @current = 'tags'

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
