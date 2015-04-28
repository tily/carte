# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
Modal = require('react-bootstrap/lib/Modal')
Button = require('react-bootstrap/lib/Button')

module.exports = React.createClass
  displayName: 'Edit'

  getInitialState: ()->
    updating: false
    title: @props.card.get('title')
    content: @props.card.get('content')

  onChangeTitle: ->
    @setState title: event.target.value

  onChangeContent: ->
    @setState content: event.target.value

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

  render: ->
    <Modal bsStyle='default' title='New card' animation={false}>
      <div className='modal-body'>
        <form>
          <div className="form-group">
            <input type="text" className="form-control" value={@state.title} onChange={@onChangeName} disabled={@state.updating} />
          </div>
          <div className="form-group">
            <textarea rows="5" className="form-control" value={@state.content} onChange={@onChangeDescription} disabled={@state.updating} />
          </div>
          <button className="btn btn-default pull-right" onClick={@props.onRequestHide}>OK</button>
        </form>
      </div>
      <div className='modal-footer'>
      </div>
    </Modal>
