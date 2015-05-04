querystring = require('querystring')
Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    ':title' : 'show'
    ''       : 'list'

  list: (string)->
    location.hash = '/' if location.hash == ''
    console.log 'list'
    @current = 'list'
    @query = querystring.parse(string)
    console.log @query

  show: (title)->
    console.log 'show', title
    @current = 'show'
    @title = title
