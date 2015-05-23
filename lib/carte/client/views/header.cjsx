# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
Edit = require('./edit')
CardModel = require('../models/card')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')
helpers = require('../helpers')
config = require('../config')

module.exports = React.createClass
  displayName: 'Header'

  getInitialState: ()->
    searchText: ''
    isCheckedIncludeContent: false

  componentWillMount: ()->
    console.log '[views/header] component will mount'
    @onSync = ()=>
      console.log '[views/header] onSync callback'
      @card = new CardModel()
      @card._isNew = true
      @card.on 'sync', @onSync
      @forceUpdate()
    @onSync()

    @callback = ()=>
      if @props.router.query
        searchText = []
        if @props.router.query.tags
          for tag in @props.router.query.tags.split(',')
            searchText.push '#' + tag
        if @props.router.query.title
          searchText.push @props.router.query.title
        @setState searchText: searchText.join(' ')
        if @props.router.query.content
          @setState isCheckedIncludeContent: true
        @forceUpdate()
    @props.router.on "route", @callback

  componentWillUnmount: ->
    console.log '[views/header] component will unmount'
    @props.router.off "route", @callback

  onChangeIncludeContent: (event)->
    @setState isCheckedIncludeContent: !@state.isCheckedIncludeContent, ()=>
      @search() if @state.searchText != ''

  onChangeSearchText: (event)->
    @setState searchText: event.target.value

  onKeyDownSearchText: (event)->
    console.log '[views/header] onKeyDownSearchText', event
    if event.keyCode == 13 # ENTER
      event.preventDefault()
      @search()

  search: ->
    tags = []
    titles = []
    for searchText in @state.searchText.split(' ')
      if match = searchText.match(/^#(.+)/)
        tags.push(match[1])
      else
        titles.push(searchText)
    query = {}
    query.title = titles.join(' ') if titles.length > 0
    query.content = titles.join(' ') if titles.length > 0 && @state.isCheckedIncludeContent
    query.tags = tags.join(',') if tags.length > 0
    location.hash = '/?' + $.param(query)

  render: ->
    <nav className="navbar navbar-default">
      <div className="container-fluid">
        <div className="navbar-header">
          <a className="navbar-brand" onClick={helpers.reload if !config.icon_link} href={if config.icon_link then config.icon_link else "#/"}>
            <img alt="Brand" src={config.root_path + config.icon_path} width="30" height="30" />
          </a>
          <a className="navbar-brand" onClick={helpers.reload} href="#/">
            {config.title}
          </a>
        </div>
        <div>
          <form className="navbar-form navbar-left" role="search">
            <div className="form-group">
              <input type="text" className="form-control" value={@state.searchText} onChange={@onChangeSearchText} onKeyDown={@onKeyDownSearchText} placeholder='Search ...' />
            </div>
            &nbsp;
            <div className="checkbox">
              <label>
                <input type="checkbox" checked={@state.isCheckedIncludeContent} onChange={@onChangeIncludeContent} />
                Include content
              </label>
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
