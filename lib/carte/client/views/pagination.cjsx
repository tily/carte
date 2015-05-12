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
    <ul className="nav nav-pills pull-right carte-pagination">
      <li className="carte-pagination-prev">
        {
          if @props.cards.pagination
            if @props.cards.pagination.current_page > 1
              href = "#/?" + @pageParam(@props.cards.pagination.current_page - 1)
            else
              href = "#/?" + @pageParam(@props.cards.pagination.total_pages)
          else
            href = "javascript:void(0)"
          <a href={href} aria-label="Previous">
            <span aria-hidden="true">&laquo;</span>
          </a>
        }
      </li>
      <li className="carte-pagination-curr">
        {
          if @props.cards.pagination
            <a href={"#/?" + @pageParam(@props.cards.pagination.current_page)} onClick={helpers.reload}>
              {@props.cards.pagination.current_page} / {@props.cards.pagination.total_pages}
            </a>
          else
            <a href="javascript:void(0)">
              <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
            </a>
        }
      </li>
      <li className="carte-pagination-next">
        {
          if @props.cards.pagination
            if @props.cards.pagination.current_page < @props.cards.pagination.total_pages
              href = "#/?" + @pageParam(@props.cards.pagination.current_page + 1)
            else
              href = "#/?" + @pageParam(1)
          else
            href = "javascript:void(0)"
          <a href={href} aria-label="Next">
            <span aria-hidden="true">&raquo;</span>
          </a>
        }
      </li>
    </ul>
