# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')

module.exports = React.createClass
  displayName: 'Card'

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
    console.log 'render card: ', Edit
    <div className='col-sm-4' style={padding:'5px'} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
      <div className='list-group'style={margin:'0px',padding:'0px'}>
        <div className='list-group-item' style={height:'220px'}>
          <p>
            <strong>
              {@props.card.get('title')}
            </strong>
            <span className='pull-right' style={{visibility: if @state.showTools then 'visible' else 'hidden'}}>
              <ModalTrigger modal={<Edit card={@props.card} />}>
                <a href="#/">
                  <i className='glyphicon glyphicon-edit' />
                </a>
              </ModalTrigger>
              &nbsp;
              &nbsp;
              <a href={'#/' + @props.card.get('title')}>
                <i className='glyphicon glyphicon-link' />
              </a>
            </span>
          </p>
          <p>
            {@props.card.get('content')}
          </p>
        </div>
      </div>
    </div>
