# @cjsx React.DOM 
$ = require('jquery')
React = require('react')
CardCollection = require('../models/cards')
classnames = require('classnames')
markdownIt = require('markdown-it')(linkify: true)
DropdownButton = require('react-bootstrap').DropdownButton
MenuItem = require('react-bootstrap').MenuItem
ButtonGroup = require('react-bootstrap').ButtonGroup
Button = require('react-bootstrap').Button

window.onerror = (error, url, line) -> alert error

module.exports = React.createClass
  displayName: 'FlashContent'
  scrollEventNames: ['touchstart', 'touchmove', 'touchend', 'gesturestart', 'gesturechange', 'gestureend']

  componentDidMount: ->
    console.log '[views/flash_content] componentDidMount', @props
    $(document).on 'keydown', @onKeyDown
    for eventName in @scrollEventNames
      $(document).on eventName, @preventScroll

    @setState currCards: @props.cards

    if @props.cards.at(0)
      @setState currCard: @props.cards.at(0), =>
        @loadNextCards()
        @loadPrevCards()
        @forceUpdate.bind(@, null)
    else
      @props.cards.on 'sync', =>
        @setState currCard: @props.cards.at(0), =>
          @loadNextCards()
          @loadPrevCards()
          @forceUpdate.bind(@, null)

  componentWillUnmount: ->
    console.log '[views/flash_content] FlashMain componentWillUnmount'
    $(document).off 'keydown', @onKeyDown
    for eventName in @scrollEventNames
      $(document).off eventName, @preventScroll

  onKeyDown: (event)->
    switch event.keyCode
      when 27 then @props.router.navigate(@closeLink())
      when 37 then @onClickPrev()
      when 39 then @onClickNext()

  preventScroll: (event)->
    tagName = event.target.tagName.toLowerCase()
    return if tagName == 'button' || tagName == 'a'
    event.preventDefault()

  getInitialState: ->
    currCard: null
    currCards: null
    nextCards: null
    prevCards: null
    hiding: true
    showTools: false
    menuOpen: false

  prevCard: ->
    _prevCard = @state.currCards.at(@currCardIndex() - 1)
    console.log '[views/flash_content] prevCard', _prevCard
    _prevCard

  nextCard: ->
    _nextCard = @state.currCards.at(@currCardIndex() + 1)
    console.log '[views/flash_content] nextCard', _nextCard
    _nextCard

  currCardIndex: ->
    _currCardIndex = @state.currCards.indexOf(@state.currCard)
    console.log '[views/flash_content] currCardIndex, @state.currCard', @state.currCard
    console.log '[views/flash_content] currCardIndex', _currCardIndex
    _currCardIndex

  currPage: ->
    _currPage = @state.currCards.pagination.current_page
    console.log '[views/flash_content] currPage', _currPage
    _currPage

  totalPages: ->
    @state.currCards.pagination.total_pages

  nextPage: ->
    _nextPage = if @currPage() < @totalPages() then @currPage() + 1 else 1
    console.log '[views/flash_content] nextPage', _nextPage
    _nextPage

  prevPage: ->
    _prevPage = if @currPage() > 1 then @currPage() - 1 else @totalPages()
    console.log '[views/flash_content] prevPage', _prevPage
    _prevPage

  loadNextCards: ->
    console.log '[views/flash_content] loadNextCards'
    nextCards = new CardCollection()
    nextCards.query = $.extend {}, @state.currCards.query, {page: @nextPage()}
    nextCards.fetching = true
    nextCards.fetch success: ()-> nextCards.fetching = false
    @setState nextCards: nextCards

  loadPrevCards: ->
    console.log '[views/flash_content] loadPrevCards'
    prevCards = new CardCollection()
    prevCards.query = $.extend {}, @state.currCards.query, {page: @prevPage()}
    prevCards.fetching = true
    prevCards.fetch success: ()-> prevCards.fetching = false
    @setState prevCards: prevCards

  onTouchStart: (event)->
    touchStart =
      x: event.touches[0].pageX
      y: event.touches[0].pageY
      time: new Date 
    if !@tapped
      @tapped = setTimeout =>
        @touchStart = touchStart
        @touchDelta = {}
        @tapped = null
      , 300
    else
      clearTimeout @tapped
      @tapped = null
      @setState showTools: !@state.showTools

  onTouchMove: (event)->
     return if !@touchStart
     return if ( event.touches.length > 1 || event.scale && event.scale != 1)

     @touchDelta =
       x: event.touches[0].pageX - @touchStart.x
       y: event.touches[0].pageY - @touchStart.y

  onTouchEnd: (event)->
    return if !@touchStart
    duration = new Date - @touchStart.time
    isValid = Number(duration) < 250 && Math.abs(@touchDelta.x) > 20
    if @touchDelta.x < 0
      @onClickNext()
    else
      @onClickPrev()
    @touchStart = null

  onClickNext: ->
    if @props.cards.query.hide != 'none' && @state.hiding
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
    if @props.cards.query.hide != 'none' && @state.hiding
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
    delete params.auto
    delete params.hide
    '#/?' + $.param(params)

  onChangeHide: (event)->
    @setState hideValue: event.target.value

  onMouseOverTools: ()->
    @setState showTools: true

  onMouseLeaveTools: ()->
    @setState showTools: false

  queryParam: (query)->
    query = $.extend {}, @props.cards.query, query
    $.param(query)

  onClickMenuItem: (params)->
    ()=> window.location.hash = '#/?' + @queryParam(params)

  onTouchStartTools: (event)->
    event.stopPropagation()

  render: ->
    clearInterval @interval if @interval
    if @props.cards.query.auto != 'off'
      bpm = null
      switch @props.cards.query.auto
        when 'fast' then bpm = 90
        when 'normal' then bpm = 60
        when 'slow' then bpm = 30 
      @interval = setInterval @onClickNext, 1000 * 60 / bpm
    <div onTouchStart={@onTouchStart} onTouchMove={@onTouchMove} onTouchEnd={@onTouchEnd} className="carte-flash">
      <div onTouchStart={@onTouchStartTools} style={position:'absolute',bottom:0,width:'100%',padding:'47px 0px 0px 0px'} onMouseOver={@onMouseOverTools} onMouseLeave={@onMouseLeaveTools}>
        <span className={classnames("pull-right":true, 'carte-hidden': !@state.showTools)}>
          <ButtonGroup>
            <DropdownButton bsSize='large' bsStyle='default' title={'Auto: ' + @props.cards.query.auto} dropup pullRight className={classnames('open': @state.menuOpen)}>
              <MenuItem href={"#/?" + @queryParam(auto: "off")} eventKey='1'>off</MenuItem>
              <MenuItem href={"#/?" + @queryParam(auto: "fast")} eventKey='2'>fast</MenuItem>
              <MenuItem href={"#/?" + @queryParam(auto: "normal")} eventKey='3'>normal</MenuItem>
              <MenuItem href={"#/?" + @queryParam(auto: "slow")} eventKey='4'>slow</MenuItem>
            </DropdownButton>
            <DropdownButton bsSize='large' bsStyle='default' title={'Hide: ' + @props.cards.query.hide} dropup pullRight className={classnames('open': @state.menuOpen)}>
              <MenuItem href={"#/?" + @queryParam(hide: "none")} eventKey='1'>none</MenuItem>
              <MenuItem href={"#/?" + @queryParam(hide: "title")} eventKey='2'>title</MenuItem>
              <MenuItem href={"#/?" + @queryParam(hide: "content")} eventKey='3'>content</MenuItem>
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
                if @props.cards.query.hide == 'title' && @state.hiding == true
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
              if @props.cards.query.hide == 'content' && @state.hiding == true
                '???????'
              else
                <div dangerouslySetInnerHTML={__html: markdownIt.render @state.currCard.get('content')} />
            else
              <i className="glyphicon glyphicon-refresh glyphicon-refresh-animate" />
          }
        </div>
      </div>
    </div>
