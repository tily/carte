# @cjsx React.DOM 
$ = require('jquery')
window.React = React = require('react')
CardCollection = require('../models/cards')
config = require('../config')
helpers = require('../helpers')
classnames = require('classnames')
markdownIt = require('markdown-it')(linkify: true)
DropdownButton = require('react-bootstrap').DropdownButton
MenuItem = require('react-bootstrap').MenuItem
ButtonGroup = require('react-bootstrap').ButtonGroup
Button = require('react-bootstrap').Button

#window.onerror = (error, url, line) -> alert error

Portal = React.createClass
  componentDidMount: ->
    console.log '[views/slideshow] Portal#componentDidMount'
    @setState currCards: @props.cards
    $(document).on 'keydown', @onKeyDown
    @props.cards.on 'sync', =>
      @setState currCard: @props.cards.at(0)
      @loadNextCards()
      @loadPrevCards()
      @forceUpdate.bind(@, null)

  componentWillUnmount: ->
    $(document).off 'keydown', @onKeyDown

  onKeyDown: (event)->
    switch event.keyCode
      when 27 then @props.router.navigate(@closeLink())
      when 37 then @onClickPrev()
      when 39 then @onClickNext()

  getInitialState: ->
    currCard: null
    currCards: null
    nextCards: null
    prevCards: null
    hideValue: 'none'
    hiding: true
    showTools: false

  prevCard: ->
    _prevCard = @state.currCards.at(@currCardIndex() - 1)
    console.log '[views/slideshow] prevCard', _prevCard
    _prevCard

  nextCard: ->
    _nextCard = @state.currCards.at(@currCardIndex() + 1)
    console.log '[views/slideshow] nextCard', _nextCard
    _nextCard

  currCardIndex: ->
    _currCardIndex = @state.currCards.indexOf(@state.currCard)
    console.log '[views/slideshow] currCardIndex, @state.currCard', @state.currCard
    console.log '[views/slideshow] currCardIndex', _currCardIndex
    _currCardIndex

  currPage: ->
    _currPage = @state.currCards.pagination.current_page
    console.log '[views/slideshow] currPage', _currPage
    _currPage

  totalPages: ->
    @state.currCards.pagination.total_pages

  nextPage: ->
    _nextPage = if @currPage() < @totalPages() then @currPage() + 1 else 1
    console.log '[views/slideshow] nextPage', _nextPage
    _nextPage

  prevPage: ->
    _prevPage = if @currPage() > 1 then @currPage() - 1 else @totalPages()
    console.log '[views/slideshow] prevPage', _prevPage
    _prevPage

  loadNextCards: ->
    console.log '[views/slideshow] loadNextCards'
    nextCards = new CardCollection()
    nextCards.query = $.extend {}, @state.currCards.query, {page: @nextPage()}
    nextCards.fetching = true
    nextCards.fetch success: ()-> nextCards.fetching = false
    @setState nextCards: nextCards

  loadPrevCards: ->
    console.log '[views/slideshow] loadPrevCards'
    prevCards = new CardCollection()
    prevCards.query = $.extend {}, @state.currCards.query, {page: @prevPage()}
    prevCards.fetching = true
    prevCards.fetch success: ()-> prevCards.fetching = false
    @setState prevCards: prevCards

  onTouchStart: (event)->
    @touchStartX = event.changedTouches[0].pageX

  onTouchEnd: (event)->
    touchEndX = event.changedTouches[0].pageX
    distance = touchEndX - @touchStartX
    if Math.abs(distance) > 100
      if distance > 0
        @onClickNext()
      else
        @onClickPrev()

  onClickNext: ->
    if @state.hideValue != 'none' && @state.hiding
      @setState hiding: false
    else
      @setState hiding: true
      if nextCard = @nextCard()
        @setState currCard: nextCard
      else
        return if @state.nextCards.fetching
        @setState currCards: @state.nextCards, prevCards: @state.currCards, ()=>
          @setState currCard: @state.currCards.at(0), ()=>
            @loadNextCards()

  onClickPrev: ->
    if @state.hideValue != 'none' && @state.hiding
      @setState hiding: false
    else
      @setState hiding: true
      if prevCard = @prevCard()
        @setState currCard: prevCard
      else
        return if @state.prevCards.fetching
        @setState currCards: @state.prevCards, nextCards: @state.currCards, ()=>
          @setState currCard: @state.currCards.at(@state.currCards.length - 1), ()=>
            @loadPrevCards()

  closeLink: ->
    params = $.extend {}, @props.cards.query
    delete params.mode
    '#/?' + $.param(params)

  onChangeHide: (event)->
    @setState hideValue: event.target.value

  onMouseOverTools: ()->
    console.log '[views/flash] onMouseEnterTools'
    @setState showTools: true

  onMouseLeaveTools: ()->
    console.log '[views/flash] onMouseLeaveTools'
    @setState showTools: false

  render: ->
    <div onTouchStart={@onTouchStart} onTouchEnd={@onTouchEnd} style={overflow:'hidden'}>
      <div style={position:'absolute',bottom:0,width:'100%',padding:0} onMouseOver={@onMouseOverTools} onMouseLeave={@onMouseLeaveTools}>
        <span className={classnames("pull-right":true, 'carte-hidden': !@state.showTools)}>
          <ButtonGroup>
            <DropdownButton bsSize='large' bsStyle='default' title='Auto: Off' dropup pullRight>
              <MenuItem eventKey='1'>Off</MenuItem>
              <MenuItem eventKey='2'>High Speed</MenuItem>
              <MenuItem eventKey='3'>Middle Speed</MenuItem>
              <MenuItem eventKey='4'>Low Speed</MenuItem>
            </DropdownButton>
            <DropdownButton bsSize='large' bsStyle='default' title='Hide: None' dropup pullRight>
              <MenuItem onClick={@onClickHide} eventKey='1'>None</MenuItem>
              <MenuItem onClick={@onClickHide} eventKey='2'>Title</MenuItem>
              <MenuItem onClick={@onClickHide} eventKey='3'>Content</MenuItem>
            </DropdownButton>
            <Button bsSize='large' href={@closeLink()}><strong>&times;</strong></Button>
          </ButtonGroup>
        </span>
      </div>
      <div style={fontSize:'10vh',padding:'1vh 5vh',overflow:'hidden'}>
        <div>
          <strong>
            {
              if @state.currCard
                if @state.hideValue == 'title' && @state.hiding == true
                  '?????'
                else
                  @state.currCard.get('title')
              else
                <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
            }
          </strong>
        </div>
        <div style={paddingTop:'5vh',overflow:'hidden'}>
          {
            if @state.currCard
              if @state.hideValue == 'content' && @state.hiding == true
                '???????'
              else
                <div dangerouslySetInnerHTML={__html: markdownIt.render @state.currCard.get('content')} />
            else
              <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
          }
        </div>
      </div>
    </div>

MyPortal = React.createFactory Portal

module.exports = React.createClass
  displayName: 'Slideshow'

  componentDidMount: ->
    console.log '[views/slideshow] componentDidMount'
    @props.cards.on 'sync', @forceUpdate.bind(@, null)
    @node = document.createElement('div')
    @node.className = 'carte-slideshow'
    document.body.appendChild(@node)
    @renderSlideshow()

  componentWillReceiveProps: (nextProps)->
    console.log '[views/slideshow] componentWillReceiveProps', nextProps
    nextProps.cards.on 'sync', @forceUpdate.bind(@, null)

  componentWillUnmount: ->
    console.log '[views/slideshow] componentWillUnmount'
    document.body.removeChild(@node)

  renderSlideshow: ->
    React.render(MyPortal(@props), @node)

  render: ->
    console.log '[views/slideshow] render', @props
    null
