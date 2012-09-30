class BattleView extends Backbone.View
  el: ".section#battle"

  initialize: ->
    @model.on "change:round", (battleModel, newValue) =>
      @_setRound(battleModel, newValue)

    @model.on "change:diceRolled", (model, newValue) =>
      @_setDiceRolled(model, newValue)

    @model.on "change:roundResolved", (model, newValue) =>
      @_setRoundResolved(model, newValue)

    @model.on "change:newBattle", (model, isNewBattle) =>
      @render() if isNewBattle


    @attacker = new BattleForceView
      el: @$el.find('.attacker')
      stance: 'attacker'
      combatType: 'space'

    @defender = new BattleForceView
      el: @$el.find('.defender')
      stance: 'defender'
      combatType: 'space'

    # Get current players from view if set
    # Or start with the current player and some other player
    if @attacker.$el.data('player') is 0
      @setAttackingPlayer state.player

    if @defender.$el.data('player') is 0
      id = state.player.id + 1
      @setDefendingPlayer(Players.get(id) || Players.get(1))

  events:
    "click a[href=#roll-dice]": "rollDiceHandler"
    "click a[href=#reset-dice]": "resetDiceHandler"
    "click a[href=#resolve-round]": "resolveRoundHandler"
    "click a[href=#next-round]": "nextRoundHandler"
    "click a[href=#new-battle]": "newBattleHandler"
    "click a[href=#new-space-combat]": "newSpaceCombatHandler"
    "click a[href=#new-ground-combat]": "newGroundCombatHandler"

  rollDiceHandler: (e) ->
    e.preventDefault()
    @model.rollDice()

  resetDiceHandler: (e) ->
    e.preventDefault()
    @model.resetDice()

  resolveRoundHandler: (e) ->
    e.preventDefault()
    @model.resolveDamage()

  nextRoundHandler: (e) ->
    e.preventDefault()
    # move battle to next round

  newBattleHandler: (e) ->
    e.preventDefault()
    @_toggleNewBattleOptions()

  newSpaceCombatHandler: (e) ->
    e.preventDefault()
    @model.newBattle("space")
    @_toggleNewBattleOptions(false)

  newGroundCombatHandler: (e) ->
    e.preventDefault()
    @model.newBattle("ground")
    @_toggleNewBattleOptions(false)

  setPlayer: (side, player) ->
    @model[side].setPlayer player

  setAttackingPlayer: (player) ->
    @setPlayer('attacker', player)

  setDefendingPlayer: (player) ->
    @setPlayer('defender', player)

  showRoundSummary: ->
    @roundSummary ?= new RoundSummaryView(model: @model)
    @roundSummary.show()


  _toggleNewBattleOptions: (showOptions) ->
    options = @$el.find(".new-battle-action .options")
    showOptions ?= options.hasClass "hidden"
    @$el.find(".new-battle.btn").text(if showOptions then "X" else "New Battle")
    options.toggleClass("hidden", not showOptions)


  _setRound: (battleModel, round) ->
    el = @$el.find(".round")
    el.toggleClass("zero", round is 0)
    el.find(".default .value").text(round)

  _setDiceRolled: (battleModel, isRolled) ->
    @$el.toggleClass "dice-rolled", isRolled

  _setRoundResolved: (battleModel, isResolved) ->
    @$el.toggleClass "round-resolved", isResolved
    @showRoundSummary()

  render: ->
    @$el.removeClass "space ground"
    @$el.addClass @model.getCombatType()
    # redraw forces
    @attacker.render()
    @defender.render()
