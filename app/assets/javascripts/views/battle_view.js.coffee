class ti3.BattleView extends Backbone.View
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


    @attacker = new ti3.BattleForceView
      el: @$el.find('.attacker')
      stance: 'attacker'
      combatType: 'space'

    @defender = new ti3.BattleForceView
      el: @$el.find('.defender')
      stance: 'defender'
      combatType: 'space'

    # Get current players from view if set
    # Or start with the current player and some other player
    if @attacker.$el.data('player') is 0
      @setAttackingPlayer state.player

    if @defender.$el.data('player') is 0
      number = state.player.getNumber() + 1
      player = state.game.getPlayer(number) or state.game.getPlayer(1)
      @setDefendingPlayer player

  events:
    "click a[href=#roll-dice]": "_rollDiceHandler"
    "click a[href=#reset-dice]": "_resetDiceHandler"
    "click a[href=#resolve-round]": "_resolveRoundHandler"
    "click a[href=#skip-pre-combat]": "_skipPreCombatHandler"
    "click a[href=#next-round]": "_nextRoundHandler"
    "click a[href=#new-battle]": "_newBattleHandler"
    "click a[href=#new-space-combat]": "_newSpaceCombatHandler"
    "click a[href=#new-ground-combat]": "_newGroundCombatHandler"

  _rollDiceHandler: (e) ->
    e.preventDefault()
    @model.rollDice()

  _resetDiceHandler: (e) ->
    e.preventDefault()
    @model.resetDice()

  _resolveRoundHandler: (e) ->
    e.preventDefault()
    @model.resolveDamage()

  _skipPreCombatHandler: (e) ->
    e.preventDefault()
    @model.nextRound()

  _nextRoundHandler: (e) ->
    e.preventDefault()
    # move battle to next round

  _newBattleHandler: (e) ->
    e.preventDefault()
    @_toggleNewBattleOptions()

  _newSpaceCombatHandler: (e) ->
    e.preventDefault()
    @model.newBattle("space")
    @_toggleNewBattleOptions(false)

  _newGroundCombatHandler: (e) ->
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
    @roundSummary ?= new ti3.RoundSummaryView(model: @model)
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
