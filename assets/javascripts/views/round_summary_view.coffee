# @model is the Battle instance
class RoundSummaryView extends Backbone.View
  el: $("#battle .round-summary")

  initialize: ->
    elForce = @$el.find(".force.template").removeClass("template").remove()
    elUnit = elForce.find(".unit.template").removeClass("template").remove()

    @forceTemplate = _.template elForce[0].outerHTML
    @unitTemplate = _.template elUnit[0].outerHTML

  events:
    "click a[href=#done]": "doneHandler"
    "click a[href=#next-round]": "nextRoundHandler"
    "click a[href=#start-invasion-combat]": "startInvasionCombatHandler"

  show: ->
    @render()
    @$el.removeClass "hidden"

  hide: ->
    @$el.addClass "hidden"

  render: ->
    e = @$el
    battleFinished = @model.finished()
    # Has the battle finished? I.e. one side has zero units left
    if battleFinished
      e.addClass "finished"
      if winner = @model.winner()
        e.addClass "win"
        e.find("h2 strong").text winner.player.race.getName()
      else
        e.addClass "draw"

    # Round number
    e.find(".round .value").text @model.getRound()

    # Add attacking forces
    e.find(".forces").html ""

    for force in [@model.attacker, @model.defender]
      elForce = $ @forceTemplate
        player:
          name: force.player.getName()
        race:
          name: force.player.race.getName()
        hits: force.hits()
        damage: force.getDamage()
        losses: force.totalUnitsLost()

      elForce.addClass "#{force.id} race-#{force.player.race.id} color-#{force.player.getColor()}"
      e.find(".forces").append elForce

      # Display units in force
      elUnits = elForce.find(".units")
      units = _.filter force.units, (unit) ->
        unit.getQuantityBefore() > 0

      for unit in units
        obj = unit.toJSON()
        elUnit = $ @unitTemplate(obj)
        elUnits.append elUnit
        # insert formatted rolls
        new DiceRollsView(hit: obj.battle, rolls: obj.rolls, el: elUnit.find(".rolls")).render()

    # What buttons do we have available
    if battleFinished
      e.find(".next-round.btn").addClass "hidden"
      if winner? and winner.stance() is "attacker"
        e.find(".start-invasion-combat").removeClass "hidden"

    this

  doneHandler: (e) ->
    e.preventDefault()

  nextRoundHandler: (e) ->
    e.preventDefault()
    @model.nextRound()
    @hide()

  startInvasionCombatHandler: (e) ->
    e.preventDefault()
    @model.newBattle "ground"
    @hide()
