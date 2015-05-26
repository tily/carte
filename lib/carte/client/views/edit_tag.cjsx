# @cjsx React.DOM 
$ = require('jquery')
React = require('react/addons')
Modal = require('react-bootstrap/lib/Modal')
Button = require('react-bootstrap/lib/Button')

module.exports = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  displayName: 'EditTag'

  getInitialState: ()->
    updating: false
    name: @props.tag.get('name')
    errors: false
    shaking: false

  onChangeName: (event)->
    @setState name: event.target.value

  onClickOk: (event)->
    event.preventDefault()
    @setState updating: true
    attributes = {new_name: @state.name}
    @props.tag.save attributes,
      success: ()=>
        @props.tag.set 'name', @state.name
        @props.onRequestHide()
      error: (model, response, options)=>
        @setState errors: response.responseJSON.tag.errors
        @setState updating: false
        @setState shaking: true
        setTimeout (=> @setState shaking: false), 300

  render: ->
    <Modal className={"animated infinite shake" if @state.shaking} {...@props} bsStyle='default' title={<i className="glyphicon glyphicon-edit" />} animation={false}>
      <div className='modal-body'>
        {
          if @state.errors
            <div className="alert alert-danger" role="alert">
              <ul>
                {
                  for key, errors of @state.errors
                    for error in errors
                      <li>{key + ' ' + error}</li>
                }
              </ul>
            </div>
        }
        <div className="form-group">
          <label className="control-label">Name</label>
          <input type="text" className="form-control" value={@state.name} onChange={@onChangeName} disabled={@state.updating} id="inputError1" />
        </div>
        <div className="form-group">
          <button className="btn btn-default pull-right" onClick={@onClickOk} disabled={@state.updating}>
            &nbsp;
            OK
            &nbsp;
            {
              if @state.updating
                <i className='glyphicon glyphicon-refresh glyphicon-refresh-animate' />
            }
          </button>
        </div>
      </div>
    </Modal>
