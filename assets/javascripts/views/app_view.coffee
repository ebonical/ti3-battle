class AppView extends Backbone.View
  el: "body"

  initialize: ->
    if GAME_TOKEN?
      state.game = new Game(token: GAME_TOKEN)
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
    @index ?= new IndexView
    @index.reset()

  openStartGame: (e) ->
    e.preventDefault() if e?
    @_activateSection 'start'
    @start ?= new StartGameView(model: state.game)

  openDashboard: (e) ->
    e.preventDefault() if e?
    @showMainNav()
    @openBattleBoard()

  openBattleBoard: (e) ->
    e.preventDefault() if e?
    @_activateSection 'battle'
    unless state.battle?
      state.battle = new Battle
      state.battle.newBattle("space")
    @battle ?= new BattleView(model: state.battle)

  openTechTree: (e) ->
    e.preventDefault() if e?
    @_activateSection 'techtree'
    @techtree ?= new TechTreeView()
    @techtree.refresh()

  showMainNav: ->
    if not @navVisible
      @navVisible = true
      $('.main-nav').removeClass('hide')
