# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')
Glyphicon = require('react-bootstrap/lib/Glyphicon')
markdownIt = require('markdown-it')(linkify: true)
helpers = require('../helpers')
classnames = require('classnames')

module.exports = React.createClass
  displayName: 'Card'

  componentDidMount: ->
    @props.card.on 'change', @forceUpdate.bind(@, null)

  getInitialState: ()->
    showTools: false
    editing: false
    updating: false
    title: @props.card.get('title')
    content: @props.card.get('content')

  onMouseOver: ()->
    @setState showTools: true

  onMouseLeave: ()->
    @setState showTools: false

  showTools: ()->
    helpers.isMobile() || @state.showTools

  render: ->
    context = @props.card.query.context
    <div
      className={
        classnames(
          'list-group',
          'col-sm-4': context != 'none',
          'col-xs-12': context != 'none',
          'col-sm-12': context == 'none'
        )
      }
      onMouseOver={@onMouseOver}
      onMouseLeave={@onMouseLeave}
    >
        <div className={classnames('list-group-item', 'carte-card-height': context != 'none')}>
          <div className="carte-card-header">
            {
              if @props.card.get('focused') || @props.card.query.context == 'none'
                <Glyphicon glyph='star' />
            }
            <strong>
              {@props.card.get('title')}
            </strong>
            {
              if @props.card.modelName == 'Card'
                <span className={classnames('pull-right': true, 'tools': true, 'carte-hidden': !@showTools())}>
                  <ModalTrigger modal={<Edit card={@props.card} />}>
                    <a href="javascript:void(0)">
                      <Glyphicon glyph='edit' />
                    </a>
                  </ModalTrigger>
                  &nbsp;
                  &nbsp;
                  <a href={'#/' + encodeURIComponent(@props.card.get('title'))}>
                    <Glyphicon glyph='link' />
                  </a>
                </span>
              else
                <span className={classnames('pull-right': true)}>
                  <i className="fa fa-clock-o" />
                  &nbsp;
                  {@props.card.get('version')}
                </span>
            }
          </div>
          <div className="carte-card-content">
            {
              if @props.card.fetching
                <Glyphicon glyph='refresh' className='glyphicon-refresh-animate' />
              else
                <div dangerouslySetInnerHTML={__html: markdownIt.render @props.card.get('content') || ''} />
            }
          </div>
          <div className={classnames('carte-hidden': !@showTools())}>
          {
            if @props.card.get("tags")
              @props.card.get("tags").map (tag)->
                <span className="pull-right tools">
                  &nbsp;&nbsp;
                  <a href={"#/?tags=" + tag}>
                    <Glyphicon glyph='tag' />
                    &nbsp;{tag}
                  </a>
                </span>
          }
          </div>
      </div>
    </div>
