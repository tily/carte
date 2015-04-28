# @cjsx React.DOM 
React = require('react')
Edit = require('./edit')
CardModel = require('../models/card')
ModalTrigger = require('react-bootstrap/lib/ModalTrigger')

module.exports = React.createClass
  displayName: 'Header'

  render: ->
    console.log 'render header', Edit
    <nav className="navbar navbar-default" style={{padding:"0px",backgroundColor:"white"}}>
      <div className="container-fluid">
        <div className="navbar-header">
          <a className="navbar-brand" href="#/" style={{paddingTop:"10px"}}>
            <img alt="Brand" src="/images/icon.png" width="30" height="30" />
          </a>
          <a className="navbar-brand" href="#/">
            Carte
          </a>
        </div>
        <div className="collapse navbar-collapse">
          <ul className="nav navbar-nav navbar-right">
            <li>
              <ModalTrigger modal={<Edit card={new CardModel()} />}>
                <a href="#/">
                  <i className="glyphicon glyphicon-plus" />
                </a>
              </ModalTrigger>
            </li>
          </ul>
        </div>
      </div>
    </nav>
