class BattleView extends Backbone.View
  el: ".section#battle"

  initialize: ->
    state.battle = new Battle(combatType: 'space')

    state.battle.on "change:round", (battleModel, newValue) =>
      @_setRound(battleModel, newValue)

    state.battle.on "change:diceRolled", (model, newValue) =>
      @_setDiceRolled(model, newValue)

    state.battle.on "change:roundResolved", (model, newValue) =>
      @_setRoundResolved(model, newValue)

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

  rollDiceHandler: (e) ->
    e.preventDefault()
    state.battle.rollDice()

  resetDiceHandler: (e) ->
    e.preventDefault()
    state.battle.resetDice()

  resolveRoundHandler: (e) ->
    e.preventDefault()
    state.battle.resolveDamage()

  nextRoundHandler: (e) ->
    e.preventDefault()
    # move battle to next round


  setPlayer: (side, player) ->
    state.battle[side].player = player
    @[side].setPlayer player

  setAttackingPlayer: (player) ->
    @setPlayer('attacker', player)

  setDefendingPlayer: (player) ->
    @setPlayer('defender', player)

  showRoundSummary: ->
    return if @roundSummary?
    @roundSummary = new RoundSummaryView(model: state.battle)
    @roundSummary.show()


  _setRound: (battleModel, round) ->
    el = @$el.find(".round")
    el.toggleClass("zero", round is 0)
    el.find(".round-number .value").text(round)

  _setDiceRolled: (battleModel, isRolled) ->
    @$el.toggleClass "dice-rolled", isRolled

  _setRoundResolved: (battleModel, isResolved) ->
    @$el.toggleClass "round-resolved", isResolved
    @showRoundSummary()
