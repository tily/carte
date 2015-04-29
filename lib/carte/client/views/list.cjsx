# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
Cards = require('./cards')
CardCollection = require('../models/cards')

module.exports = React.createClass
  displayName: 'List'

  componentWillReceiveProps: (nextProps)->
    console.log 'List: component will receive props'
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)

  getInitialState: ()->
    searchText: ''

  onChangeSearchText: ()->
    @setState searchText: event.target.value

  onKeyPressSearchText: ()->
    if event.keyCode == 13 # ENTER
      console.log '13 enter', @props.cards.query
      event.preventDefault()
      query = $.extend {}, @props.cards.query
      query = $.extend query, {title: @state.searchText}
      location.hash = '/?' + $.param(query)

  atozParam: ()->
    query = $.extend {}, @props.cards.query
    query = $.extend query, {sort: 'title', order: 'asc', page: 1}
    delete query.seed
    $.param(query)

  latestParam: ()->
    query = $.extend {}, @props.cards.query
    query = $.extend query, {sort: 'updated_at', order: 'desc', page: 1}
    delete query.seed
    $.param(query)

  randomParam: ()->
    query = $.extend {}, @props.cards.query
    query = $.extend query, {order: 'random', page: 1, seed: new Date().getTime()}
    delete query.sort
    delete query.page
    $.param(query)

  pageParam: (page)->
    query = $.extend {}, @props.cards.query
    query = $.extend query, {page: page}
    $.param(query)

  render: ->
    console.log 'render', @props.cards.query
    <div className="container" style={{paddingLeft:"5px",paddingRight:"5px",paddingBottom:"20px"}}>
      {if @props.showNav
        <div className="row">
          <div className="col-sm-12" style={{padding:"5px"}}>
            <form>
              <div className="form-group">
                <input type="text" className="form-control" value={@state.searchText} onChange={@onChangeSearchText} onKeyPress={@onKeyPressSearchText} placeholder='Type search text and press enter ...' />
              </div>
            </form>
          </div>
          <div className="col-sm-6" style={{padding:"0px"}}>
            <ul className="nav nav-pills">
              <li><a href={"/#/?" + @atozParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.sort == 'title' and @props.cards.query.order != 'random' then 'bold' else 'normal'}}>A to Z</a></li>
              <li><a href={"/#/?" + @latestParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.sort == 'updated_at' and @props.cards.query.order != 'random' then 'bold' else 'normal'}}>Latest</a></li>
              <li><a href={"/#/?" + @randomParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.order == 'random' then 'bold' else 'normal'}}>Random</a></li>
            </ul>
          </div>
          <div className="col-sm-6" style={{padding:"0px"}}>
            {
              if @props.cards.query.order == 'random'
                <ul className="nav nav-pills pull-right">
                  <li>
                    <a href={"/#/?" + @randomParam()} style={{padding:'6px 12px'}}>
                      <i className="glyphicon glyphicon-refresh" />
                    </a>
                  </li>
                </ul>
              else
                if @props.cards.page
                  <ul className="nav nav-pills pull-right">
                    {
                      if @props.cards.page.current > 1
                        <li>
                          <a href={"/#/?" + @pageParam(@props.cards.page.current - 1)} aria-label="Previous" style={{padding:'6px 12px'}}>
                            <span aria-hidden="true">&laquo;</span>
                          </a>
                        </li>
                    }
                    <li>
                      <a href={"/#/?" + @pageParam(@props.cards.page.current)} style={{padding:'6px 12px'}}>
                        {@props.cards.page.current} / {@props.cards.page.total}
                      </a>
                    </li>
                    {
                      if @props.cards.page.current < @props.cards.page.total
                        <li>
                          <a href={"/#/?" + @pageParam(@props.cards.page.current + 1)} aria-label="Next" style={{padding:'6px 12px'}}>
                            <span aria-hidden="true">&raquo;</span>
                          </a>
                        </li>
                    }
                  </ul>
            }
          </div>
        </div>
      } 
      <Cards cards={@props.cards} />
    </div>
