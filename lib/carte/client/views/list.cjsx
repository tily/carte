# @cjsx React.DOM 
$ = require('jquery')
Backbone = require('backbone')
React = require('react')
Cards = require('./cards')
Card = require('./card')
CardCollection = require('../models/cards')
Pagination = require('./pagination')
helpers = require('../helpers')
config = require('../config')

module.exports = React.createClass
  displayName: 'List'

  componentDidMount: ->
    console.log '[views/list] component did mount'
    @props.cards.on 'sync', @forceUpdate.bind(@, null)

  componentWillReceiveProps: (nextProps)->
    console.log '[views/list] component will receive props'
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)

  atozParam: ()->
    @queryParam {sort: 'title', order: 'asc', page: 1}, []

  latestParam: ()->
    @queryParam {sort: 'updated_at', order: 'desc', page: 1}, []

  randomParam: ()->
    @queryParam {order: 'random'}, ['sort', 'page']

  tagParam: (tag)->
    @queryParam {tag: tag}, []

  queryParam: (param, deleteKeys)->
    query = $.extend {}, @props.cards.query, param
    for key in deleteKeys
      delete query[key]
    $.param(query)

  render: ->
    <div className="container carte-list">
      {if !@props.card && @props.cards.collectionName == 'Cards'
        <div className="row">
          <div className="col-sm-4">
            <ul className="nav nav-pills">
              {
                for menuItem in config.menu_items
                  switch menuItem
                    when 'atoz'
                      <li key='atoz'>
                        <a onClick={helpers.reload} href={"#/?" + @atozParam()}>
                          {
                            if @props.cards.query.sort == 'title' and @props.cards.query.order != 'random'
                              <strong>A to Z</strong>
                            else
                              <span>A to Z</span>
                          }
                        </a>
                      </li>
                    when 'latest'
                      <li key='latest'>
                        <a onClick={helpers.reload} href={"#/?" + @latestParam()}>
                          {
                            if @props.cards.query.sort == 'updated_at' and @props.cards.query.order != 'random'
                              <strong>Latest</strong>
                            else
                              <span>Latest</span>
                          }
                        </a>
                      </li>
                    when 'random'
                      <li key='random'>
                        <a onClick={helpers.reload} href={"#/?" + @randomParam()}>
                          {
                            if @props.cards.query.order == 'random'
                              <strong>Random</strong>
                            else
                              <span>Random</span>
                          }
                        </a>
                      </li>
              }
              <li>
                <a href={"#/tags"}>
                  <i className="glyphicon glyphicon-tag" />
                </a>
              </li>
              <li>
                <a href={config.root_path + config.api_path + "/cards.xml?" + @queryParam({}, [])}>
                  <i className="fa fa-rss" />
                </a>
              </li>
              <li>
                <a href={"#/?" + @queryParam({'mode': 'flash'}, [])}>
                  <i className="fa fa-arrows-alt" />
                </a>
              </li>
            </ul>
          </div>
          <div className="col-sm-4">
                <ul className="nav nav-pills nav-justified">
                  <li>
                    <a href="javascript:void(0)" className="center-block text-center">
                      <span className="badge">
                        {
                          if @props.cards.pagination
                            @props.cards.pagination.total_entries
                          else
                            <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
                        }
                      </span>
                    </a>
                  </li>
                </ul>
          </div>
          <div className="col-sm-4">
            {
              if @props.cards.query.order == 'random'
                <ul className="nav nav-pills pull-right">
                  <li>
                    {
                      if @props.cards.pagination
                        <a onClick={helpers.reload} href={"#/?" + @randomParam()}>
                          <i className="glyphicon glyphicon-refresh" />
                        </a>
                      else
                        <a href="javascript:void(0)">
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
        if @props.card
          title = @props.card.get('title')
        else
          title = @props.router.title
        <div className="row">
          <div className="col-sm-12">
            <ul className="nav nav-pills">
              <li>
                <a href={"#/" + encodeURIComponent(title) + '?context=title'}>
                  {
                    if @props.card && @props.card.query.context == 'title'
                      <strong>A to Z</strong>
                    else
                      <span>A to Z</span>
                  }
                </a>
              </li>
              <li>
                <a href={"#/" + encodeURIComponent(title) + '?context=updated_at'}>
                  {
                    if @props.card && @props.card.query.context == 'updated_at'
                      <strong>Latest</strong>
                    else
                      <span>Latest</span>
                  }
                </a>
              </li>
              <li>
                <a href={"#/" + encodeURIComponent(title) + '?context=none'}>
                  {
                    if @props.card && @props.card.query.context == 'none'
                      <strong>Detail</strong>
                    else
                      <span>Detail</span>
                  }
                </a>
              </li>
              <li>
                <a href={"#/" + encodeURIComponent(title) + '/history'}>
                  {
                    if @props.cards.collectionName == 'CardHistories'
                      <strong>History</strong>
                    else
                      <span>History</span>
                  }
                </a>
              </li>
            </ul>
          </div>
        </div>
      } 
      {
        if @props.card && @props.card.query.context == 'none'
          <div className='row'>
            <Card key={@props.card.get("title")} card={@props.card} />
          </div>
        else 
          <Cards cards={@props.cards} card={@props.card} />
      }
      {
        if !@props.card && helpers.isMobile()
          <div className="row">
            <div className="col-sm-12">
              <Pagination cards={@props.cards} />
            </div>
          </div>
      }
    </div>
