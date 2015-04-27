# @cjsx React.DOM 
React = require('react')
Words = require('./words.cjsx')
WordCollection = require('../models/words')

module.exports = React.createClass
  displayName: 'List'

  getInitialState: ()->
    searchText: 'test'
    query: {sort_key: 'name', sort_order: 'asc'}

  onChangeSearchText: ()->
    @setState searchText: event.target.value

  onKeyPressSearchText: ()->
    if event.keyCode == 13 # ENTER
      console.log '13 enter'
      event.preventDefault()
      @props.words.query = {name: @state.searchText, sort_key: 'name', sort_order: 'asc'}
      @props.words.fetch()

  onClickAtoz: ()->
      @setState query: {sort_key: 'name', sort_order: 'asc'}
      @props.words.query = @state.query
      @props.words.fetch()

  onClickLatest: ()->
      @setState query: {sort_key: 'updated_at', sort_order: 'desc'}
      @props.words.query = @state.query
      @props.words.fetch()

  onClickRandom: ()->
      @setState query: {sort_order: 'random'}
      @props.words.query = @state.query
      @props.words.fetch()

  render: ->
    <div className="container" style={{paddingLeft:"5px",paddingRight:"5px",paddingBottom:"20px"}}>
      {if @props.showNav
        <div className="row">
          <div className="col-sm-12" style={{padding:"5px"}}>
            <form>
              <div className="form-group">
                <input type="text" className="form-control" value={@state.searchText} onChange={@onChangeSearchText} onKeyPress={@onKeyPressSearchText} />
              </div>
            </form>
          </div>
          <div className="col-sm-6" style={{padding:"0px"}}>
            <ul className="nav nav-pills">
              <li><a href="#/" style={{padding: '6px 12px', fontWeight: if @state.query.sort_key == 'name' then 'bold' else 'normal'}} onClick={@onClickAtoz}>A to Z</a></li>
              <li><a href="#/" style={{padding:'6px 12px',fontWeight: if @state.query.sort_key == 'updated_at' then 'bold' else 'normal'}} onClick={@onClickLatest}>Latest</a></li>
              <li><a href="#/" style={{padding:'6px 12px',fontWeight: if @state.query.sort_order == 'random' then 'bold' else 'normal'}} onClick={@onClickRandom}>Random</a></li>
            </ul>
          </div>
          <div className="col-sm-6" style={{padding:"0px"}}>
            <ul className="nav nav-pills pull-right">
              <li>
                <a href="#/" aria-label="Previous" style={{padding:'6px 12px'}}>
                  <span aria-hidden="true">&laquo;</span>
                </a>
              </li>
              <li><a href="#/" style={{padding:'6px 12px'}}>1 / 5</a></li>
              <li>
                <a href="#/" aria-label="Next" style={{padding:'6px 12px'}}>
                  <span aria-hidden="true">&raquo;</span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      } 
      <Words words={@props.words} />
    </div>
