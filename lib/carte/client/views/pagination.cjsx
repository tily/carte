# @cjsx React.DOM 
Backbone = require('backbone')
$ = require('jquery')
React = require('react')
helpers = require('../helpers')

module.exports = React.createClass
  displayName: 'Pagination'

  pageParam: (page)->
    query = $.extend {}, @props.cards.query
    query = $.extend query, {page: page}
    $.param(query)

  render: ->
    <ul className="nav nav-pills pull-right">
      <li>
        {
          if @props.cards.page
            if @props.cards.page.current > 1
              href = "#/?" + @pageParam(@props.cards.page.current - 1)
            else
              href = "#/?" + @pageParam(@props.cards.page.total)
          else
            href = "javascript:void(0)"
          <a href={href} aria-label="Previous" style={{padding:'6px 12px'}}>
            <span aria-hidden="true">&laquo;</span>
          </a>
        }
      </li>
      <li style={width:'7.5em',textAlign:'center'}>
        {
          if @props.cards.page
            <a href={"#/?" + @pageParam(@props.cards.page.current)} onClick={helpers.reload} style={{padding:'6px 12px'}}>
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
              href = "#/?" + @pageParam(@props.cards.page.current + 1)
            else
              href = "#/?" + @pageParam(1)
          else
            href = "javascript:void(0)"
          <a href={href} aria-label="Next" style={{padding:'6px 12px'}}>
            <span aria-hidden="true">&raquo;</span>
          </a>
        }
      </li>
    </ul>
