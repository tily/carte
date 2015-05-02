# @cjsx React.DOM 
$ = require('jquery')
React = require('react/addons')
Modal = require('react-bootstrap/lib/Modal')
Button = require('react-bootstrap/lib/Button')
TagsInput = require('react-tagsinput')

module.exports = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  displayName: 'Edit'

  getInitialState: ()->
    updating: false
    title: @props.card.get('title')
    content: @props.card.get('content')
    tags: @props.card.get('tags') || []
    errors: false

  onChangeTitle: ->
    @setState title: event.target.value

  onChangeContent: ->
    @setState content: event.target.value

  onClickOk: ()->
    event.preventDefault()
    @setState updating: true
    if @props.card.isNew()
      attributes = {title: @state.title, content: @state.content, tags: @state.tags}
    else
      attributes = {new_title: @state.title, content: @state.content, tags: @state.tags}
    @props.card.save attributes,
      success: ()=>
        @setState updating: false
        @props.onRequestHide()
        @props.card.set 'title', @state.title
        if @props.card.isNew()
          location.hash = '/' + @state.title
      error: (model, response, options)=>
        console.log response.responseJSON
        @setState errors: response.responseJSON.card.errors
        @setState updating: false

  render: ->
    <Modal {...@props} bsStyle='default' title={if @props.card.isNew() then <i className="glyphicon glyphicon-plus" /> else <i className="glyphicon glyphicon-edit" />} animation={false}>
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
