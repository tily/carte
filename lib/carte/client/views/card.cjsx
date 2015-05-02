# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')
markdownIt = require('markdown-it')(linkify: true)

module.exports = React.createClass
  displayName: 'Card'
  isSafariOrUiWebView: /(iPhone|iPod|iPad).*AppleWebKit/i.test(navigator.userAgent)

  componentDidMount: ->
    @props.card.on 'change', @forceUpdate.bind(@, null)
    @props.card.on 'change', (model)->
      console.log 'change', model

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
    console.log 'Card: render'
    <div className='col-sm-4 col-xs-12 list-group' style={marginBottom:'0px',padding:"5px"} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
        <div className='list-group-item' style={height:'220px'}>
          <div>
            {
              if @props.card.get('focused')
                <i className='glyphicon glyphicon-star' style={marginRight:'5px'} />
            }
            <strong>
              {@props.card.get('title')}
            </strong>
            <span className='pull-right' style={{visibility: if @isSafariOrUiWebView || @state.showTools then 'visible' else 'hidden'}}>
              <ModalTrigger modal={<Edit card={@props.card} />}>
                <a href="javascript:void(0)">
                  <i className='glyphicon glyphicon-edit' />
                </a>
              </ModalTrigger>
              &nbsp;
              &nbsp;
              <a href={'#/' + @props.card.get('title')}>
                <i className='glyphicon glyphicon-link' />
              </a>
            </span>
          </div>
          <div style={overflow:'hidden',width:'100%',height:'80%',wordWrap:'break-word'}>
            <p dangerouslySetInnerHTML={__html: markdownIt.render @props.card.get('content')} />
          </div>
      </div>
    </div>
