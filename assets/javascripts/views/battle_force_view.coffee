class BattleForceView extends Backbone.View
  initialize: ->
    @playerEl = $('h3.name', @$el)
    @playerTemplate = _.template(@playerEl.html())

    state.battle.on "change:diceRolled", (model, isRolled) =>
      @_setHitsFromOpponent(model, isRolled)

  events:
    "click a[href=#clear-units]": "clearUnitsHandler"
    "click a[href=#adjust-battle-values]": "adjustBattleValuesHandler"
    "click a[href=#adjust-damage-values]": "adjustDamageValuesHandler"

  stance: ->
    @options.stance

  opponentStance: ->
    if @stance() is "defender" then "attacker" else "defender"

  setPlayer: (player) ->
    @player = player
    @$el.data('player', @player.id)
    @render()

  clearUnitsHandler: (e) ->
    e.preventDefault()
    state.battle[@stance()].clearUnits()

  adjustBattleValuesHandler: (e) ->
    e.preventDefault()
    # toggle class
    @$el.toggleClass 'adjusting-battle-values'

  adjustDamageValuesHandler: (e) ->
    e.preventDefault()
    console.warn "adjustDamageValuesHandler: not yet implemented"

  _setHitsFromOpponent: (model, isRolled) ->
    $('.hits-from-opponent .value', @$el).text model[@opponentStance()].hits()

  render: ->
    # Make sure the current race and colour classes are set
    @$el.removeClass ->
      _.filter $(this).attr('class').split(' '), (klass) ->
        /^(race|color)-/.test(klass)

    @$el.addClass "race-#{@player.get("race").id} color-#{@player.get("color")}"

    @playerEl.html @playerTemplate(@player.toJSON())

    # Units
    @units = []
    oob = @$el.find('.order-of-battle .units').html('')

    for unit in state.battle[@options.stance].units
      view = new BattleUnitView(model: unit, id: unit.cid, className: "unit zero #{unit.id}")
      oob.append view.render().el
      @units.push view

    this
  # end render
