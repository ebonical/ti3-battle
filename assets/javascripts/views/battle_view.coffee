class BattleView extends Backbone.View
  el: ".section#battle"

  initialize: ->
    state.battle = new Battle(combatType: 'space')

    state.battle.on "change:round", (battleModel, newValue) =>
      @_setRound(battleModel, newValue)

    state.battle.on "change:diceRolled", (model, newValue) =>
      @_setDiceRolled(model, newValue)

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

  rollDiceHandler: (e) ->
    e.preventDefault()
    state.battle.rollDice()

  resetDiceHandler: (e) ->
    e.preventDefault()
    state.battle.resetDice()

  setPlayer: (side, player) ->
    state.battle[side].player = player
    @[side].setPlayer player

  setAttackingPlayer: (player) ->
    @setPlayer('attacker', player)

  setDefendingPlayer: (player) ->
    @setPlayer('defender', player)

  _setRound: (battleModel, round) ->
    el = @$el.find(".round")
    el.toggleClass("zero", round is 0)
    $(".round-number .value", el).text(round)

  _setDiceRolled: (battleModel, isRolled) ->
    @$el.toggleClass "dice-rolled", isRolled
