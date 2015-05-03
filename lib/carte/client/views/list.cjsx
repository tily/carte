# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
Cards = require('./cards')
CardCollection = require('../models/cards')
Pagination = require('./pagination')
helpers = require('../helpers')

module.exports = React.createClass
  displayName: 'List'

  componentDidMount: ->
    @props.cards.on 'sync', @forceUpdate.bind(@, null)

  componentWillReceiveProps: (nextProps)->
    console.log 'List: component will receive props'
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)

  atozParam: ()->
    @queryParam {sort: 'title', order: 'asc', page: 1}, ['seed']

  latestParam: ()->
    @queryParam {sort: 'updated_at', order: 'desc', page: 1}, ['seed']

  randomParam: ()->
    @queryParam {order: 'random', page: 1, seed: new Date().getTime()}, ['sort', 'page']

  tagParam: (tag)->
    @queryParam {tag: tag}, ['seed']

  queryParam: (param, deleteKeys)->
    query = $.extend {}, @props.cards.query
    query = $.extend query, param
    for key in deleteKeys
      delete query[key]
    $.param(query)

  render: ->
    console.log 'render', @props.cards.query
    <div className="container" style={{paddingLeft:"5px",paddingRight:"5px"}}>
      {if !@props.card
        <div className="row">
          <div className="col-sm-6" style={{padding:"0px"}}>
            <ul className="nav nav-pills">
              <li><a href={"#/?" + @atozParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.sort == 'title' and @props.cards.query.order != 'random' then 'bold' else 'normal'}}>A to Z</a></li>
              <li><a href={"#/?" + @latestParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.sort == 'updated_at' and @props.cards.query.order != 'random' then 'bold' else 'normal'}}>Latest</a></li>
              <li><a href={"#/?" + @randomParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.order == 'random' then 'bold' else 'normal'}}>Random</a></li>
              {
                if @props.cards.query.tags
                  @props.cards.query.tags.split(',').map (tag)=>
                    <li><a href={"#/?" + @tagParam(tag)} style={padding:'6px 12px'}><i className="glyphicon glyphicon-tag" />&nbsp;{tag}</a></li>
              }
            </ul>
          </div>
          <div className="col-sm-6" style={{padding:"0px"}}>
            {
              if @props.cards.query.order == 'random'
                <ul className="nav nav-pills pull-right">
                  <li>
                    {
                      if @props.cards.page
                        <a href={"#/?" + @randomParam()} style={{padding:'6px 12px'}}>
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
                <Pagination cards={@props.cards} />
            }
          </div>
        </div>
      else
        <div className="row">
          <div className="col-sm-12" style={{padding:"0px"}}>
            <ul className="nav nav-pills">
              <li><a href={"#/" + @props.card.get('title')} style={fontWeight:'bold'}>{@props.card.get('title')}</a></li>
            </ul>
          </div>
        </div>
      } 
      <Cards cards={@props.cards} />
      {
        if !@props.card && helpers.isMobile()
          <div className="row">
            <div className="col-sm-12" style={{padding:"0px"}}>
              <Pagination cards={@props.cards} />
            </div>
          </div>
      }
    </div>
