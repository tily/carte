# @cjsx React.DOM 
React = require('react')

module.exports = React.createClass
  displayName: 'Header'

  render: ->
    <nav className="navbar navbar-default" style={{padding:"0px",backgroundColor:"white"}}>
      <div className="container-fluid">
        <div className="navbar-header">
          <a className="navbar-brand" href="#/">
            <img alt="Brand" src="/images/icon.png" width="20" height="20" />
          </a>
          <a className="navbar-brand" href="#/">
            carte
          </a>
        </div>
        <div className="collapse navbar-collapse">
          <ul className="nav navbar-nav navbar-right">
            <li>
              <a href="#/">
                <i className="glyphicon glyphicon-plus" />
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
