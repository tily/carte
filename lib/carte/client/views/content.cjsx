# @cjsx React.DOM 
React = require('react')
List = require('./list.cjsx')
WordCollection = require('../models/words')
WordModel = require('../models/word')

module.exports = React.createClass
  displayName: 'Content'

  componentWillMount: ->
    console.log 'componentWillMount'
    @callback = ()=> console.log @; @forceUpdate()
    @props.router.on "route", @callback

  componentWillUnmount: ->
    console.log 'componentWillMount un'
    @props.router.off "route", @callback

  render: ->
    console.log 'render component'
    switch @props.router.current
      when "list"
        console.log 'list'
        words = new WordCollection()
        words.query = {sort_key: 'name', sort_order: 'asc'}
        words.fetch()
        <List key='list' words={words} showNav=true />
      when "show"
        console.log 'show'
        words = new WordCollection()
        word = new WordModel(name: @props.router.name)
        word.fetch
          success: (word)->
            console.log word
            for l in word.get("lefts")
              wordModel = new WordModel(l)
              console.log 'adding l', wordModel
              words.add wordModel
            words.add word
            for r in word.get("rights")
              wordModel = new WordModel(r)
              console.log 'adding r', wordModel
              words.add wordModel
        <List key='show' words={words} showNav=false />
      else
        console.log 'else'
        <div>Loading ...</div>
