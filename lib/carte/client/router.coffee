Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    ':title'     : 'show'
    ''          : 'list'

  list: ()->
    console.log 'list'
    @current = 'list'

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
