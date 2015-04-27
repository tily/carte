querystring = require('querystring')
Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    ':title' : 'show'
    ''       : 'list'

  list: (string)->
    console.log 'list'
    @current = 'list'
    @query = querystring.parse(string)
    console.log @query

  new: ()->
    console.log 'new'
    @current = 'new'

  edit: (title)->
    console.log 'edit', title
    @current = 'edit'
    @title = title

  show: (title)->
    console.log 'show', title
    @current = 'show'
    @title = title
