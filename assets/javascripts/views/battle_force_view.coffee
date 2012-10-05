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
    "click a[href=#clear-units]": "_clearUnitsHandler"
    "click a[href=#adjust-battle-values]": "_adjustBattleValuesHandler"
    "click a[href=#adjust-damage-values]": "_adjustDamageValuesHandler"
    "click a[href=#clear-damage]": "_clearDamageHandler"
    "click a[href=#change-player]": "_changePlayerHandler"

  stance: ->
    @options.stance

  oppositeStance: ->
    if @stance() is "defender" then "attacker" else "defender"

  battleForce: ->
    state.battle[@stance()]

  setPlayer: (player) ->
    @player = player
    @$el.data('player', @player.getNumber())
    @render()


  _clearUnitsHandler: (e) ->
    e.preventDefault()
    unless $(e.target).hasClass("disabled")
      @battleForce().clearUnits()

  _adjustBattleValuesHandler: (e) ->
    e.preventDefault()
    @_toggleAdjustingBattleValues()

  _adjustDamageValuesHandler: (e) ->
    e.preventDefault()
    unless $(e.target).hasClass "disabled"
      console.warn "_adjustDamageValuesHandler: not yet implemented"

  _clearDamageHandler: (e) ->
    e.preventDefault()
    unit.clearDamage() for unit in @battleForce().units

  _changePlayerHandler: (e) ->
    e.preventDefault()
    new OptionPickerView
      title: 'Select Player'
      options: _.map(state.game.players, (p) ->
                label = "#{p.race.getName()} : #{p.getName()}"
                [p.getNumber(), label]
              )
      selected: @player.getNumber()
      callback: @_selectOptionPlayer

  _selectOptionPlayer: (selectedPlayerNumber) =>
    player = state.game.getPlayer(+selectedPlayerNumber)
    @battleForce().setPlayer player


  _setDiceHaveBeenRolled: (battleModel, isRolled) ->
    @$el.removeClass "adjusting-battle-values"
    totalHits = battleModel[@oppositeStance()].getHits()
    elHits = @$el.find(".hits-from-opponent")
    elHits.toggleClass "zero", totalHits is 0
    elHits.find(".value").text totalHits
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
      results = _.filter $(this).attr('class').split(' '), (klass) ->
        /^(race|color)-/.test(klass)
      results.join(' ')

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
