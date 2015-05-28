# @cjsx React.DOM 
$ = require('jquery')
Backbone = require('backbone')
React = require('react')
classnames = require('classnames')
Cards = require('./cards')
Card = require('./card')
CardCollection = require('../models/cards')
Pagination = require('./pagination')
helpers = require('../helpers')
config = require('../config')
Glyphicon = require('react-bootstrap/lib/Glyphicon')

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
                          <span className={classnames('carte-strong': @props.cards.query.sort == 'title' and @props.cards.query.order != 'random')}>A to Z</span>
                        </a>
                      </li>
                    when 'latest'
                      <li key='latest'>
                        <a onClick={helpers.reload} href={"#/?" + @latestParam()}>
                          <span className={classnames('carte-strong': @props.cards.query.sort == 'updated_at' and @props.cards.query.order != 'random')}>Latest</span>
                        </a>
                      </li>
                    when 'random'
                      <li key='random'>
                        <a onClick={helpers.reload} href={"#/?" + @randomParam()}>
                          <span className={classnames('carte-strong': @props.cards.query.order == 'random')}>Random</span>
                        </a>
                      </li>
              }
              <li>
                <a href={"#/tags"}>
                  <Glyphicon glyph='tag' />
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
                         <Glyphicon glyph='refresh' className='glyphicon-refresh-animate' />
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
                          <Glyphicon glyph='refresh' />
                        </a>
                      else
                        <a href="javascript:void(0)">
                          <Glyphicon glyph='refresh' className='glyphicon-refresh-animate' />
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
                  <span className={classnames('carte-strong': @props.card && @props.card.query.context == 'title')}>A to Z</span>
                </a>
              </li>
              <li>
                <a href={"#/" + encodeURIComponent(title) + '?context=updated_at'}>
                  <span className={classnames('carte-strong': @props.card && @props.card.query.context == 'updated_at')}>Latest</span>
                </a>
              </li>
              <li>
                <a href={"#/" + encodeURIComponent(title) + '?context=none'}>
                  <span className={classnames('carte-strong': @props.card && @props.card.query.context == 'none')}>Detail</span>
                </a>
              </li>
              <li>
                <a href={"#/" + encodeURIComponent(title) + '/history'}>
                  <span className={classnames('carte-strong': @props.cards.collectionName == 'CardHistories')}>History</span>
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
