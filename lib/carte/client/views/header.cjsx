# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
CardModel = require('../models/card')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')

module.exports = React.createClass
  displayName: 'Header'

  componentWillMount: ()->
    console.log 'header mounted'
    @card = new CardModel()
    @card._isNew = true
    @card.on 'sync', (model)=>
      console.log 'sync!!!'
      @card = new CardModel()
      @card._isNew = true
      @forceUpdate()

  render: ->
    <nav className="navbar navbar-default" style={{padding:"0px",backgroundColor:"white"}}>
      <div className="container-fluid">
        <div className="navbar-header">
          <a className="navbar-brand" href="#/" style={{paddingTop:"10px"}}>
            <img alt="Brand" src="/images/icon.png" width="30" height="30" />
          </a>
          <a className="navbar-brand" href="#/">
          </a>
        </div>
        <div className="collapse navbar-collapse">
          <ul className="nav navbar-nav navbar-right">
            <li>
              <ModalTrigger modal={<Edit card={@card} />}>
                <a href="javascript:void(0)">
                  <i className="glyphicon glyphicon-plus" />
                </a>
              </ModalTrigger>
            </li>
          </ul>
        </div>
      </div>
    </nav>
