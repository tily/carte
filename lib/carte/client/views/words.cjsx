# @cjsx React.DOM 
React = require('react')
Word = require('./word.cjsx')

module.exports = React.createClass
  displayName: 'Words'

  componentDidMount: ()->
    @props.words.on 'add remove change', @forceUpdate.bind(@, null)
    @props.words.on 'add', (model)->
      console.log 'add', model 

  render: ->
    console.log 'render words'
    if @props.words.length > 0
      console.log 'words loaded'
      words = @props.words.map (word)-> <Word key={word.get("name")} word={word} />
      <div className='row'>{words}</div>
    else
      console.log 'words loading'
      <div>Loading ...</div>
