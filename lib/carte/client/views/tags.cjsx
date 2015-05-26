# @cjsx React.DOM 
$ = require('jquery')
Backbone = require('backbone')
React = require('react')
EditTag = require('./edit_tag')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')

module.exports = React.createClass
  displayName: 'Tags'

  componentDidMount: ->
    console.log '[views/tags] component did mount'
    @props.tags.on 'sync', @forceUpdate.bind(@, null)

  componentWillReceiveProps: (nextProps)->
    console.log '[views/tags] component will receive props'
    nextProps.tags.on 'sync', @forceUpdate.bind(@, null)

  render: ->
    <div className="container carte-list">
        <div className="row">
          <div className="col-sm-12">
            <ul className="nav nav-pills">
               <li>
                 <a href="#/">
                   <i className="glyphicon glyphicon-arrow-left" />
                 </a>
               </li>
            </ul>
          </div>
        </div>

        <div className="row">
          {
            if @props.tags.fetching
              <div className="list-group col-sm-4">
                <div className="list-group-item">
                  <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
                </div>
              </div>
            else
              @props.tags.map (tag)->
                <div className="list-group col-sm-4">
                  <div className="list-group-item">
                    <i className="glyphicon glyphicon-tag" />
                    &nbsp;
                    {tag.get('name')}
                    &nbsp;
                    (
                    <a href={'#/?tags=' + encodeURIComponent(tag.get('name'))}>
                      {tag.get('count')}
                    </a>
                    )
                    <span className="pull-right tools">
                      <ModalTrigger modal={<EditTag tag={tag} />}>
                        <a href="javascript:void(0)">
                          <i className="glyphicon glyphicon-edit" />
                        </a>
                      </ModalTrigger>
                    </span>
                  </div>
                </div>
          }
        </div>
    </div>
