React = require('react')
Backbone = require('backbone')
$ = require('jquery')
cssify = require('cssify')
AppViewComponent = require('./client/views/app')
Router = require('./client/router')

Backbone.$ = $
cssify.byUrl('//maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css')
cssify.byUrl('//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css')

$(document).ready ()->
  AppView = React.createFactory(AppViewComponent)
  appView = AppView(router: new Router)
  React.render appView, document.getElementById('app')
