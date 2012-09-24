# @model is the Battle instance
class RoundSummaryView extends Backbone.View
  el: $("#battle .round-summary")

  initialize: ->
    forceEl = @$el.find(".force.template").removeClass("template").remove()
    unitEl = forceEl.find(".unit.template").removeClass("template").remove()
    @forceTemplate = _.template(forceEl[0].outerHTML)
    @unitTemplate = _.template(unitEl[0].outerHTML)


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
        e.find("h2 strong").text winner.player.get("race").get("name")
      else
        e.addClass "draw"

    # Round number
    e.find(".round .value").text @model.get("round")

    # Add attacking forces
    e.find(".forces").html ""

    for force in [@model.attacker, @model.defender]
      forceEl = $ @forceTemplate
        player:
          name: force.player.get("name")
        race:
          name: force.player.get("race").get("name")

      forceEl.addClass "#{force.stance()} race-#{force.player.get("race").id} color-#{force.player.get("color")}"
      e.find(".forces").append forceEl
      # Summary sentence
      totalHits = force.hits()
      totalDamage = force.get("damage")
      totalLosses = force.totalUnitsLost()
      overview = "Inflicted #{totalHits} hit#{if totalHits is 1 then '' else 's'}" +
        " to the other side and took #{totalDamage} damage" +
        " losing #{totalLosses} ship#{if totalLosses is 1 then '' else 's'}."
      forceEl.find(".overview").text overview

      # Display units in force
      unitsEl = forceEl.find(".units")
      units = _.filter force.units, (unit) ->
        unit.get("quantityBefore") > 0

      for unit in units
        obj = unit.toJSON()
        unitEl = $ @unitTemplate(obj)
        unitsEl.append unitEl
        # insert formatted rolls
        new DiceRollsView(hit: obj.battle, rolls: obj.rolls, el: unitEl.find(".rolls")).render()
        # hide plural losses
        unitEl.find(".losses .plural").toggleClass("hidden", obj.losses is 1)

    # What buttons do we have available
    if battleFinished
      e.find(".next-round.btn").addClass "hidden"
      if winner? and winner.stance() is "attacker"
        e.find(".start-invasion").removeClass "hidden"

    this

  doneHandler: (e) ->
    e.preventDefault()

  nextRoundHandler: (e) ->
    e.preventDefault()
    @model.nextRound()
    @hide()

  startInvasionCombatHandler: (e) ->
    e.preventDefault()

