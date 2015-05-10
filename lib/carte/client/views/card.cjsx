# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')
markdownIt = require('markdown-it')(linkify: true)
helpers = require('../helpers')

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

  render: ->
    <div className='col-sm-4 col-xs-12 list-group' style={marginBottom:'0px',padding:"5px"} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
        <div className='list-group-item' style={height:'200px'}>
          <div style={marginBottom:'10px'}>
            {
              if @props.card.get('focused')
                <i className='glyphicon glyphicon-star' style={marginRight:'5px'} />
            }
            <strong>
              {@props.card.get('title')}
            </strong>
            <span className='pull-right tools' style={{visibility: if helpers.isMobile() || @state.showTools then 'visible' else 'hidden'}}>
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
          <div className="card" style={overflow:'hidden',width:'100%',height:'73%',wordWrap:'break-word'}>
            <div dangerouslySetInnerHTML={__html: markdownIt.render @props.card.get('content')} />
          </div>
          <div style={{visibility: if helpers.isMobile() || @state.showTools then 'visible' else 'hidden'}}>
          {
            if @props.card.get("tags")
              @props.card.get("tags").map (tag)->
                <span className="pull-right tools">&nbsp;&nbsp;<a href={"#/?tags=" + tag}><i className="glyphicon glyphicon-tag" />&nbsp;{tag}</a></span>
          }
          </div>
      </div>
    </div>
