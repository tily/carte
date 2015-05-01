# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')
markdownIt = require('markdown-it')(linkify: true)

module.exports = React.createClass
  displayName: 'Card'

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
    style = {height:'220px'}
    if @props.card.get('focused')
      #style.color = 'red'
      style.borderColor = '#ccc'
    <div className='col-sm-4' style={padding:'5px'} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
      <div className='list-group' style={margin:'0px',padding:'0px'}>
        <div className='list-group-item' style={style}>
          <div>
            {
              if @props.card.get('focused')
                <i className='glyphicon glyphicon-star' style={marginRight:'5px'} />
            }
            <strong>
              {@props.card.get('title')}
            </strong>
            <span className='pull-right' style={{visibility: if @state.showTools then 'visible' else 'hidden'}}>
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
          <div style={overflow:'scroll',width:'100%',height:'80%',wordWrap:'break-word'}>
            <p>
              <div dangerouslySetInnerHTML={__html: markdownIt.render @props.card.get('content')} />
            </p>
          </div>
        </div>
      </div>
    </div>
