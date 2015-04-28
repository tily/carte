# @cjsx React.DOM 
Backbone = require('backbone')
React = require('react')
Header = require('./header')
Content = require('./content')
Footer = require('./footer')

module.exports = React.createClass
  displayName: 'App'

  componentDidMount: ->
    Backbone.history.start() 

  render: ->
    Button = require('react-bootstrap/lib/Button')
    <div>
      <Header key='header' />
      <Content key='content' router={@props.router} />
      <Footer key='footer' />
    </div>

