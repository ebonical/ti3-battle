class ti3.AppView extends Backbone.View
  el: "body"

  initialize: ->
    if GAME_TOKEN?
      state.game = new ti3.Game(token: GAME_TOKEN)
      state.game.fetch
        success: (model, data) =>
          model.initialize()
          @openStartGame()
    else
      history.replaceState({}, "New Game", "/")
      @openIndex()
      # @openTechTree()

  events:
    "click .main-nav a[href=#dashboard]": "openDashboard"
    "click .main-nav a[href=#battle]": "openBattleBoard"
    "click .main-nav a[href=#techtree]": "openTechTree"
    "click .main-nav a[href=#sync]": "syncData"


  toggleMainNav: (show) ->
    $('.main-nav').toggleClass "hide", not show

  _activateSection: (section) ->
    $('.section.active').removeClass 'active'
    $(".section##{section}").addClass 'active'
    $(".main-nav li.active").removeClass 'active'
    $(".main-nav li.#{section}").addClass 'active'


  openIndex: (e) ->
    e.preventDefault() if e?
    @_activateSection 'index'
    @index ?= new ti3.IndexView
    @index.reset()

  openStartGame: (e) ->
    e.preventDefault() if e?
    @_activateSection 'start'
    @start ?= new ti3.StartGameView(model: state.game)

  openDashboard: (e) ->
    e.preventDefault() if e?
    @showMainNav()
    @openBattleBoard()

  openBattleBoard: (e) ->
    e.preventDefault() if e?
    @_activateSection 'battle'
    unless state.battle?
      state.battle = new ti3.Battle
      state.battle.newBattle("space")
    @battle ?= new ti3.BattleView(model: state.battle)

  openTechTree: (e) ->
    e.preventDefault() if e?
    @_activateSection 'techtree'
    @techtree ?= new ti3.TechTreeView()
    @techtree.refresh()

  syncData: (e) ->
    e.preventDefault()
    if not @_listeningToGameUpdate
      state.game.on 'updated', (model) =>
        @_finishedSync()
    @$el.find('.main-nav .sync').addClass 'loading'
    state.game.update()

  _finishedSync: ->
    console.log 'finished sync'
    @$el.find('.main-nav .sync').removeClass 'loading'

  showMainNav: ->
    if not @navVisible
      @navVisible = true
      $('.main-nav').removeClass('hide')
