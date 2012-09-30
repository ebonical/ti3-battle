class BattleForceView extends Backbone.View

  playerTemplate: _.template $(".battle-board .force h3.name .template").html()

  initialize: ->
    state.battle.on "change:diceRolled", (model, isRolled) =>
      @_setDiceHaveBeenRolled(model, isRolled)

    @battleForce().on "change:player", (model, player) =>
      @setPlayer(player)

    @battleForce().on "change:damage", (model, newValue) =>
      @_setDamageApplied(newValue)


  events:
    "click a[href=#clear-units]": "clearUnitsHandler"
    "click a[href=#adjust-battle-values]": "adjustBattleValuesHandler"
    "click a[href=#adjust-damage-values]": "adjustDamageValuesHandler"
    "click a[href=#clear-damage]": "clearDamageHandler"

  stance: ->
    @options.stance

  oppositeStance: ->
    if @stance() is "defender" then "attacker" else "defender"

  battleForce: ->
    state.battle[@stance()]

  setPlayer: (player) ->
    @player = player
    @$el.data('player', @player.id)
    @render()


  clearUnitsHandler: (e) ->
    e.preventDefault()
    unless $(e.target).hasClass("disabled")
      @battleForce().clearUnits()

  adjustBattleValuesHandler: (e) ->
    e.preventDefault()
    @_toggleAdjustingBattleValues()

  adjustDamageValuesHandler: (e) ->
    e.preventDefault()
    unless $(e.target).hasClass "disabled"
      console.warn "adjustDamageValuesHandler: not yet implemented"

  clearDamageHandler: (e) ->
    e.preventDefault()
    unit.clearDamage() for unit in @battleForce().units


  _setDiceHaveBeenRolled: (battleModel, isRolled) ->
    @$el.removeClass "adjusting-battle-values"
    @$el.find(".hits-from-opponent .value").text battleModel[@oppositeStance()].getHits()
    @_toggleAdjustingBattleValues false

  _setDamageApplied: (damage) ->
    el = @$el.find(".damage-applied")
    el.toggleClass "zero", damage is 0
    el.find(".value").text damage

  _toggleAdjustingBattleValues: (turnOn) ->
    e = @$el
    turnOn ?= not e.hasClass("adjusting-battle-values")
    e.toggleClass "adjusting-battle-values", turnOn
    e.find(".force-actions .clear-units a, .force-actions .adjust-damage-values a").toggleClass "disabled", turnOn
    e.find(".force-actions .adjust-battle-values a").text(if turnOn then "Done" else "Battle Values")



  render: ->
    # Make sure the current race and colour classes are set
    @$el.removeClass ->
      _.filter $(this).attr('class').split(' '), (klass) ->
        /^(race|color)-/.test(klass)

    @$el.addClass "race-#{@player.race.id} color-#{@player.getColor()}"

    @$el.find("h3.name").html @playerTemplate(@player.toJSON())

    # Units
    @units = []
    oob = @$el.find(".order-of-battle .units").html("")

    for unit in @battleForce().units
      view = new BattleUnitView(model: unit, id: unit.cid, className: "unit zero #{unit.id}")
      oob.append view.render().el
      @units.push view

    this
  # end render
