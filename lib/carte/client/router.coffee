querystring = require('querystring')
Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    '': 'list'
    'slideshow': 'slideshow'
    ':title': 'show'

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

  slideshow: (string)->
    console.log 'slideshow', string
    @current = 'slideshow'
    @query = querystring.parse(string)
