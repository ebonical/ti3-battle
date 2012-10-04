class AppView extends Backbone.View
  el: "body"

  initialize: ->
    if GAME_TOKEN?
      state.game = new Game(token: GAME_TOKEN)
      state.game.fetch
        success: (model, response) =>
          model.initialize()
          @openStartGame()
    else
      @openIndex()


  events:
    "click .main-nav a[href=#battle]": "openBattleBoard"


  toggleMainNav: (show) ->
    $('.main-nav').toggleClass "hide", not show


  openIndex: (e) ->
    e.preventDefault() if e?
    $('.section.active').removeClass 'active'
    $('.section#index').addClass 'active'
    @index ?= new IndexView
    @index.reset()

  openStartGame: (e) ->
    console.log "opening start game..."
    e.preventDefault() if e?
    $('.section.active').removeClass 'active'
    $('.section#start').addClass 'active'
    # @start ?= new StartGameView(model: state.game)

  openBattleBoard: (e) ->
    e.preventDefault() if e?
    $('.section.active').removeClass('active')
    $('.section#battle').addClass('active')
    unless state.battle?
      state.battle = new Battle
      state.battle.newBattle("space")
    @battle ?= new BattleView(model: state.battle)
