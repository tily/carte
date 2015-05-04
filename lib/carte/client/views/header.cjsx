# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
Edit = require('./edit')
CardModel = require('../models/card')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')
helpers = require('../helpers')
config = require('../../shared/config.json')

module.exports = React.createClass
  displayName: 'Header'

  getInitialState: ()->
    searchText: ''

  componentWillMount: ()->
    console.log 'header mounted'
    @card = new CardModel()
    @card._isNew = true
    @card.on 'sync', (model)=>
      console.log 'sync!!!'
      @card = new CardModel()
      @card._isNew = true
      @forceUpdate()

    console.log 'componentWillMount'
    @callback = ()=>
      searchText = []
      if @props.router.query.tags
        for tag in @props.router.query.tags.split(',')
          searchText.push '#' + tag
      if @props.router.query.title
        searchText.push @props.router.query.title
      @setState searchText: searchText.join(' ')
      @forceUpdate()
    @props.router.on "route", @callback

  componentWillUnmount: ->
    console.log 'componentWillMount un'
    @props.router.off "route", @callback

  onChangeSearchText: ()->
    @setState searchText: event.target.value

  onKeyPressSearchText: ()->
    if event.keyCode == 13 # ENTER
      console.log '13 enter'
      event.preventDefault()
      tags = []
      titles = []
      for searchText in @state.searchText.split(' ')
        if match = searchText.match(/^#(.+)/)
          tags.push(match[1])
        else
          titles.push(searchText)
      query = {}
      query.title = titles.join(' ') if titles.length > 0
      query.tags = tags.join(',') if tags.length > 0
      location.hash = '/?' + $.param(query)

  render: ->
    <nav className="navbar navbar-default" style={{padding:"0px",backgroundColor:"white",marginBottom:"5px"}}>
      <div className="container-fluid">
        <div className="navbar-header">
          <a className="navbar-brand" onClick={helpers.reload} href={if config.icon_link then config.icon_link else "#/"} style={{paddingTop:"10px"}}>
            <img alt="Brand" src="/images/icon.png" width="30" height="30" />
          </a>
          <a className="navbar-brand" onClick={helpers.reload} href="#/">
            {config.title}
          </a>
        </div>
        <div>
          <form className="navbar-form navbar-left" role="search">
            <div className="form-group">
              <input type="text" className="form-control" value={@state.searchText} onChange={@onChangeSearchText} onKeyPress={@onKeyPressSearchText} placeholder='Search ...' style={width:"344px"} />
            </div>
          </form>
          <ul className="nav navbar-nav navbar-right">
            <li>
              <ModalTrigger modal={<Edit card={@card} />}>
                <a href="javascript:void(0)">
                  <i className="glyphicon glyphicon-plus" />
                </a>
              </ModalTrigger>
            </li>
          </ul>
        </div>
      </div>
    </nav>
