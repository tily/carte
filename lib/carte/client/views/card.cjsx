# @cjsx React.DOM 
React = require('react')

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

  onChangeName: ()->
    @setState title: event.target.value

  onChangeDescription: ()->
    @setState content: event.target.value

  onClickEdit: ()->
    event.preventDefault()
    @setState editing: true

  onClickOk: ()->
    @setState updating: true
    event.preventDefault()
    attributes = {new_title: @state.title, content: @state.content}
    console.log attributes
    @props.card.save attributes,
      success: ()=>
        @setState editing: false
        @props.card.set 'title', attributes.new_title
        @setState updating: false
      error: (model, response, options)=>
        message = ''
        for key, errors of response.responseJSON.card.errors
          for error in errors
            message += key + ' ' + error + "\n"
        console.log 'error', model, response, options
        alert message
        @setState updating: false

  onClickCancel: ()->
    return if @updating
    event.preventDefault()
    @setState editing: false

  render: ->
    <div className='col-sm-4' style={padding:'5px'} onMouseOver={@onMouseOver} onMouseLeave={@onMouseLeave}>
      <div className='list-group'style={margin:'0px',padding:'0px'}>
        <div className='list-group-item' style={height:'220px'}>
          {
            if @state.editing
              <form>
                <div className="form-group" style={marginBottom:"5px"}>
                  <input type="text" className="form-control input-sm" value={@state.title} onChange={@onChangeName} disabled={@state.updating} />
                </div>
                <div className="form-group" style={marginBottom:"5px"}>
                  <textarea rows="5" className="form-control input-sm" value={@state.content} onChange={@onChangeDescription} disabled={@state.updating} />
                </div>
                <button className="btn btn-default btn-xs" onClick={@onClickOk} disabled={@state.updating}>OK</button>
                <a className="pull-right" href="javascript:void(0)" onClick={@onClickCancel}><small>Cancel</small></a>
              </form>
            else
              <div>
                <p>
                  <strong>
                    {@props.card.get('title')}
                  </strong>
                  <span className='pull-right' style={{visibility: if @state.showTools then 'visible' else 'hidden'}}>
                    <a href="javascript:void(0)" onClick={@onClickEdit}>
                      <i className='glyphicon glyphicon-edit' />
                    </a>
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
          }
        </div>
      </div>
    </div>
