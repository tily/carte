# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
Cards = require('./cards')
CardCollection = require('../models/cards')

module.exports = React.createClass
  displayName: 'List'

  componentDidMount: ->
    @props.cards.on 'sync', @forceUpdate.bind(@, null)

  componentWillReceiveProps: (nextProps)->
    console.log 'List: component will receive props'
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)

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
    <div className="container" style={{paddingLeft:"5px",paddingRight:"5px"}}>
      {if !@props.card
        <div className="row">
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
                    {
                      if @props.cards.page
                        <a href={"/#/?" + @randomParam()} style={{padding:'6px 12px'}}>
                          <i className="glyphicon glyphicon-refresh" />
                        </a>
                      else
                        <a href="javascript:void(0)" style={{padding:'6px 12px'}}>
                          <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
                        </a>
                    }
                  </li>
                </ul>
              else
                <ul className="nav nav-pills pull-right">
                  <li>
                    {
                      if @props.cards.page
                        if @props.cards.page.current > 1
                          href = "/#/?" + @pageParam(@props.cards.page.current - 1)
                        else
                          href = "/#/?" + @pageParam(@props.cards.page.total)
                      else
                        href = "javascript:void(0)"
                      <a href={href} aria-label="Previous" style={{padding:'6px 12px'}}>
                        <span aria-hidden="true">&laquo;</span>
                      </a>
                    }
                  </li>
                  <li style={width:'4.0em',textAlign:'center'}>
                    {
                      if @props.cards.page
                        <a href={"/#/?" + @pageParam(@props.cards.page.current)} style={{padding:'6px 12px'}}>
                          {@props.cards.page.current} / {@props.cards.page.total}
                        </a>
                      else
                        <a href="javascript:void(0)" style={{padding:'6px 12px'}}>
                          <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
                        </a>
                    }
                  </li>
                  <li>
                    {
                      if @props.cards.page
                        if @props.cards.page.current < @props.cards.page.total
                          href = "/#/?" + @pageParam(@props.cards.page.current + 1)
                        else
                          href = "/#/?" + @pageParam(1)
                      else
                        href = "javascript:void(0)"
                      <a href={href} aria-label="Next" style={{padding:'6px 12px'}}>
                        <span aria-hidden="true">&raquo;</span>
                      </a>
                    }
                  </li>
                </ul>
            }
          </div>
        </div>
      else
        <div className="row">
          <div className="col-sm-12" style={{padding:"0px"}}>
            <ul className="nav nav-pills">
              <li><a href={"/#/" + @props.card.get('title')} style={fontWeight:'bold'}>{@props.card.get('title')}</a></li>
            </ul>
          </div>
        </div>
      } 
      <Cards cards={@props.cards} />
    </div>
