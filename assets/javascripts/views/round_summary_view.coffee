# @model is the Battle instance
class RoundSummaryView extends Backbone.View
  el: $("#battle .round-summary")

  forceTemplate: _.template $(".round-summary .force.template").html()
  unitTemplate: _.template $(".round-summary .unit.template").html()

  initialize: ->
    @model.on "change:roundResolved", (model, isResolved) =>
      @hide() if not isResolved

    @conditionalButtons =
      next: @$el.find(".next-round.btn")
      invasion: @$el.find(".start-invasion-combat.btn")


  events:
    "click a[href=#done]": "doneHandler"
    "click a[href=#next-round]": "nextRoundHandler"
    "click a[href=#start-invasion-combat]": "startInvasionCombatHandler"

  show: ->
    @render()
    @$el.modal
      keyboard: false
      backdrop: "static"

  hide: ->
    @$el.modal("hide")

  render: ->
    e = @$el
    e.removeClass("finished win draw")
    battleFinished = @model.isFinished()
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
        stance: force.stance()
        player:
          name: force.player.getName()
        race:
          name: force.player.race.getName()
        hits: force.getHits()
        damage: force.getDamage()
        losses: force.totalUnitsLost()

      elForce.addClass "force #{force.id} race-#{force.player.race.id} color-#{force.player.getColor()}"
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
    button.addClass("hidden") for key, button of @conditionalButtons

    if battleFinished
      if winner? and winner.stance() is "attacker" and @model.getCombatType() is "space"
        @conditionalButtons.invasion.removeClass "hidden"
    else
      @conditionalButtons.next.removeClass "hidden"

    this

  doneHandler: (e) ->
    e.preventDefault()
    @model.newBattle( @model.getCombatType() )

  nextRoundHandler: (e) ->
    e.preventDefault()
    @model.nextRound()
    @hide()

  startInvasionCombatHandler: (e) ->
    e.preventDefault()
    @model.newBattle("ground")
    @hide()
