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
    @state.currCards.at(@currCardIndex() - 1)

  nextCard: ->
    @state.currCards.at(@currCardIndex() + 1)

  currCardIndex: ->
    @state.currCards.indexOf(@state.currCard)

  currPage: ->
    @state.currCards.pagination.current_page

  totalPages: ->
    @state.currCards.pagination.total_pages

  nextPage: ->
    if @currPage() < @totalPages() then @currPage() + 1 else 1

  prevPage: ->
    if @currPage() > 1 then @currPage() - 1 else @totalPages()

  loadNextCards: ->
    nextCards = new CardCollection()
    nextCards.query = $.extend {}, @state.currCards.query, {page: @nextPage()}
    nextCards.fetch()
    @setState nextCards: nextCards

  loadPrevCards: ->
    prevCards = new CardCollection()
    prevCards.query = $.extend {}, @state.currCards.query, {page: @prevPage()}
    prevCards.fetch()
    @setState prevCards: prevCards

  onClickNext: ->
    if nextCard = @nextCard()
      @setState currCard: nextCard
    else
      @setState currCards: @state.nextCards, prevCards: @state.cards, ()=>
        @setState currCard: @state.currCards.at(0)
        @loadNextCards()

  onClickPrev: ->
    if prevCard = @prevCard()
      @setState currCard: prevCard
    else
      @setState currCards: @state.prevCards, nextCards: @state.cards, ()=>
        @setState currCard: @state.currCards.at(0)
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
