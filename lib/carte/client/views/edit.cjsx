# @cjsx React.DOM 
$ = require('jquery')
React = require('react/addons')
Modal = require('react-bootstrap/lib/Modal')
Button = require('react-bootstrap/lib/Button')
TagsInput = require('react-tagsinput')
CardModel = require('../models/card')

module.exports = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  displayName: 'Edit'

  getInitialState: ()->
    updating: false
    title: @props.card.get('title')
    content: @props.card.get('content')
    tags: @props.card.get('tags') || []
    errors: false
    shaking: false
    dontCloseDialog: false
    createSuccess: false

  onChangeTitle: (event)->
    @setState title: event.target.value

  onChangeContent: (event)->
    @setState content: event.target.value

  onChangeDontCloseDialog: (event)->
    @setState dontCloseDialog: !@state.dontCloseDialog

  onClickOk: (event)->
    event.preventDefault()
    @setState updating: true
    if @props.card.isNew()
      attributes = {title: @state.title, content: @state.content, tags: @state.tags}
    else
      attributes = {new_title: @state.title, content: @state.content, tags: @state.tags}
    @props.card.save attributes,
      success: ()=>
        @setState updating: false
        if @props.card.isNew()
          if @state.dontCloseDialog
            @setState
              createSuccess: true
              title: ''
              content: ''
              tags: []
            @props.card = new CardModel()
            @props.card._isNew = true
          else
            @props.onRequestHide()
            @props.card.set 'title', @state.title
            location.hash = '/' + @state.title
      error: (model, response, options)=>
        @setState errors: response.responseJSON.card.errors
        @setState updating: false
        @setState shaking: true
        setTimeout (=> @setState shaking: false), 300

  render: ->
    <Modal className={"animated infinite shake" if @state.shaking} {...@props} bsStyle='default' title={if @props.card.isNew() then <i className="glyphicon glyphicon-plus" /> else <i className="glyphicon glyphicon-edit" />} animation={false}>
      <div className='modal-body'>
        {
          if @state.errors
            <div className="alert alert-danger" role="alert" style={padding:'5px'}>
              <ul style={paddingLeft:"20px"}>
              {
                for key, errors of @state.errors
                  for error in errors
                    <li>{key + ' ' + error}</li>
              }
              </ul>
            </div>
          else if @state.createSuccess
            <div className="alert alert-success" role="alert" style={padding:'5px'}>
              <i className="glyphicon glyphicon-info-sign" />&nbsp;
              You created a card successfully. Let's create next one.
            </div>
        }
        <div className="form-group">
          <label class="control-label">Title</label>
          <input type="text" className="form-control" value={@state.title} onChange={@onChangeTitle} disabled={@state.updating} id="inputError1" />
        </div>
        <div className="form-group">
          <label class="control-label">Content</label>
          <textarea rows="10" className="form-control" value={@state.content} onChange={@onChangeContent} disabled={@state.updating} />
        </div>
        <div className="form-group">
          <label class="control-label">Tags</label>
          <TagsInput ref='tags' valueLink={this.linkState('tags')} />
        </div>
        {
          if @props.card.isNew()
            <div className="checkbox">
              <label>
                <input type="checkbox" checked={@state.dontCloseDialog} onChange={@onChangeDontCloseDialog} /> Don't Close Dialog
              </label>
            </div>
        }
        <div className="form-group" style={{paddingBottom:'17px'}}>
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
