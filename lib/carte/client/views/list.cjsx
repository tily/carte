# @cjsx React.DOM 
React = require('react')
Cards = require('./cards.cjsx')
CardCollection = require('../models/cards')

module.exports = React.createClass
  displayName: 'List'

  getInitialState: ()->
    searchText: 'test'
    query: {sort_key: 'title', sort_order: 'asc'}

  onChangeSearchText: ()->
    @setState searchText: event.target.value

  onKeyPressSearchText: ()->
    if event.keyCode == 13 # ENTER
      console.log '13 enter'
      event.preventDefault()
      @props.cards.query = {title: @state.searchText, sort_key: 'title', sort_order: 'asc'}
      @props.cards.fetch()

  onClickAtoz: ()->
      console.log 'atoz'
      query = {sort_key: 'title', sort_order: 'asc'}
      @setState query: query
      @props.cards.query = query
      @props.cards.fetch()

  onClickLatest: ()->
      console.log 'late'
      query = {sort_key: 'updated_at', sort_order: 'desc'}
      @setState query: query
      @props.cards.query = query
      @props.cards.fetch()

  onClickRandom: ()->
      console.log 'rand'
      query = {sort_order: 'random'}
      @setState query: query
      @props.cards.query = query
      @props.cards.fetch()

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
              <li><a href="#/" style={{padding:'6px 12px',fontWeight: if @state.query.sort_key == 'title' then 'bold' else 'normal'}} onClick={@onClickAtoz}>A to Z</a></li>
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
      <Cards cards={@props.cards} />
    </div>
