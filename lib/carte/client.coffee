React = require('react')
Backbone = require('backbone')
$ = require('jquery')
AppViewComponent = require('./client/views/app')
Router = require('./client/router')

Backbone.$ = $

$(document).ready ()->
  AppView = React.createFactory(AppViewComponent)
  appView = AppView(router: new Router)
  React.render appView, document.getElementById('app')
