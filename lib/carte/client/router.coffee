Backbone = require('backbone')

module.exports = class Router extends Backbone.Router
  routes:
    ':name'     : 'show'
    ''          : 'list'

  list: ()->
    console.log 'list'
    @current = 'list'

  new: ()->
    console.log 'new'
    @current = 'new'

  edit: (name)->
    console.log 'edit', name
    @current = 'edit'
    @name = name

  show: (name)->
    console.log 'show', name
    @current = 'show'
    @name = name
