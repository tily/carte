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
    event.preventDefault()
    @setState updating: true
    attributes = {new_title: @state.title, content: @state.content}
    @props.card.save attributes,
      success: ()=>
        @setState editing: false
        @props.card.set 'title', attributes.new_title
        @setState updating: false
        @props.onRequestHide()
      error: (model, response, options)=>
        message = ''
        for key, errors of response.responseJSON.card.errors
          for error in errors
            message += key + ' ' + error + "\n"
        console.log 'error', model, response, options
        alert message
        @setState updating: false

  render: ->
    <Modal bsStyle='default' title="nil" animation={false}>
      <div className='modal-body'>
        <form>
          <div className="form-group">
            <input type="text" className="form-control" value={@state.title} onChange={@onChangeName} disabled={@state.updating} />
          </div>
          <div className="form-group">
            <textarea rows="10" className="form-control" value={@state.content} onChange={@onChangeDescription} disabled={@state.updating} />
          </div>
          <button className="btn btn-default pull-right" onClick={@props.onRequestHide}>Cancel</button>
          <button className="btn btn-default pull-right" onClick={@onClickOk}>OK</button>
        </form>
      </div>
      <div className='modal-footer'>
      </div>
    </Modal>
