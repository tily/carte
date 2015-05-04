# @cjsx React.DOM 
$ = require('jquery')
Backbone = require('backbone')
React = require('react')
Cards = require('./cards')
CardCollection = require('../models/cards')
Pagination = require('./pagination')
helpers = require('../helpers')
config = require('../../shared/config')

module.exports = React.createClass
  displayName: 'List'

  componentDidMount: ->
    @props.cards.on 'sync', @forceUpdate.bind(@, null)

  componentWillReceiveProps: (nextProps)->
    console.log 'List: component will receive props'
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)

  atozParam: ()->
    @queryParam {sort: 'title', order: 'asc', page: 1}, []

  latestParam: ()->
    @queryParam {sort: 'updated_at', order: 'desc', page: 1}, []

  randomParam: ()->
    @queryParam {order: 'random'}, ['sort', 'page']

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
              <li><a onClick={helpers.reload} href={"#/?" + @atozParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.sort == 'title' and @props.cards.query.order != 'random' then 'bold' else 'normal'}}>A to Z</a></li>
              <li><a onClick={helpers.reload} href={"#/?" + @latestParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.sort == 'updated_at' and @props.cards.query.order != 'random' then 'bold' else 'normal'}}>Latest</a></li>
              <li><a onClick={helpers.reload} href={"#/?" + @randomParam()} style={{padding:'6px 12px',fontWeight: if @props.cards.query.order == 'random' then 'bold' else 'normal'}}>Random</a></li>
              <li><a href={config.api_path + "/api/cards.xml?" + @queryParam({}, [])} style={{padding:'6px 12px'}}><i className="fa fa-rss" /></a></li>
            </ul>
          </div>
          <div className="col-sm-6" style={{padding:"0px"}}>
            {
              if @props.cards.query.order == 'random'
                <ul className="nav nav-pills pull-right">
                  <li>
                    {
                      if @props.cards.page
                        <a onClick={helpers.reload} href={"#/?" + @randomParam()} style={{padding:'6px 12px'}}>
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
