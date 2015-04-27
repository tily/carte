React = require('react')
Backbone = require('backbone')
$ = require('jquery')
cssify = require('cssify')
AppViewComponent = require('./client/views/app')
Router = require('./client/router')

Backbone.$ = $
cssify.byUrl('//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css')

$(document).ready ()->
  AppView = React.createFactory(AppViewComponent)
  appView = AppView(router: new Router)
  React.render appView, document.getElementById('app')
