# @cjsx React.DOM 
$ = require('jquery')
Backbone = require('backbone')
React = require('react')
CardCollection = require('../models/cards')
config = require('../config')

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
      when 37 then @onClickPrev()
      when 39 then @onClickNext()

  getInitialState: ->
    autoplay: false
    autoplaySpeed: null 
    hide: false
    hideElement: null
    currCard: null
    currCards: null
    nextCards: null
    prevCards: null

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

  onClickNext: ->
    if nextCard = @nextCard()
      @setState currCard: nextCard
    else
      return if @state.nextCards.fetching
      @setState currCards: @state.nextCards, prevCards: @state.currCards, ()=>
        @setState currCard: @state.currCards.at(0), ()=>
          @loadNextCards()

  onClickPrev: ->
    if prevCard = @prevCard()
      @setState currCard: prevCard
    else
      return if @state.prevCards.fetching
      @setState currCards: @state.prevCards, nextCards: @state.currCards, ()=>
        @setState currCard: @state.currCards.at(@state.currCards.length - 1), ()=>
          @loadPrevCards()

  render: ->
    <div className="carte-slideshow">
      <div style={fontSize:'10vh',padding:'1vh 5vh',overflow:'hidden'}>
        <div>
          <strong>
            {
              if @state.currCard
                @state.currCard.get('title')
              else
                <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
            }
          </strong>
          <span className="pull-right">
            <strong>&times;</strong>
          </span>
        </div>
        <div style={paddingTop:'24px'}>
          {
            if @state.currCard
              @state.currCard.get('content')
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
