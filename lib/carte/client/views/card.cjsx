# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')
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
    <div className='col-sm-4 col-xs-12 list-group' onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
        <div className='list-group-item'>
          <div className="carte-card-header">
            {
              if @props.card.get('focused')
                <i className='glyphicon glyphicon-star' />
            }
            <strong>
              {@props.card.get('title')}
            </strong>
            <span className={classnames('pull-right': true, 'tools': true, 'carte-hidden': !@showTools())}>
              <ModalTrigger modal={<Edit card={@props.card} />}>
                <a href="javascript:void(0)">
                  <i className='glyphicon glyphicon-edit' />
                </a>
              </ModalTrigger>
              &nbsp;
              &nbsp;
              <a href={'#/' + encodeURIComponent(@props.card.get('title'))}>
                <i className='glyphicon glyphicon-link' />
              </a>
            </span>
          </div>
          <div className="carte-card-content">
            <div dangerouslySetInnerHTML={__html: markdownIt.render @props.card.get('content')} />
          </div>
          <div className={classnames('carte-hidden': !@showTools())}>
          {
            if @props.card.get("tags")
              @props.card.get("tags").map (tag)->
                <span className="pull-right tools">
                  &nbsp;&nbsp;
                  <a href={"#/?tags=" + tag}>
                    <i className="glyphicon glyphicon-tag" />
                    &nbsp;{tag}
                  </a>
                </span>
          }
          </div>
      </div>
    </div>
