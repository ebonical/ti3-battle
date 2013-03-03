# @model is the Battle instance
class ti3.RoundSummaryView extends Backbone.View
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
    "click a[href=#done]": "_doneHandler"
    "click a[href=#next-round]": "_nextRoundHandler"
    "click a[href=#start-invasion-combat]": "_startInvasionCombatHandler"

  show: ->
    @render()
    @$el.modal
      keyboard: false
      backdrop: "static"

  hide: ->
    @$el.modal("hide")

  getPromotionsText: (force) ->
    output = []
    outcome = force.getPromotions()
    p = outcome.promotions
    d = outcome.demotions
    if p > 0 and p is d
      output.push "Ground Force would have been promoted but you only have 1 left."
    else
      if p > 0
        output.push "#{p} #{'Ground Troop'.pluralize(p)} to be promoted."
      if d > 0
        output.push "1 Shock Troop will be demoted."
    output.join("<br>")

  render: ->
    el = @$el
    el.removeClass("finished win draw")
    battleFinished = @model.isFinished()
    # Has the battle finished? I.e. one side has zero units left
    if battleFinished
      el.addClass "finished"
      if winner = @model.winner()
        el.addClass "win"
        el.find("h2 strong").text winner.player.race.getName()
      else
        el.addClass "draw"

    # Round number
    el.find(".round .value").text @model.getRound()

    # Add attacking forces
    el.find(".forces").html ""

    elPromotionsNotice = el.find('.promotions-notice')
    elPromotionsNotice.hide()

    for force in [@model.attacker, @model.defender]
      elForce = @forceTemplate
        stance: force.stance()
        player: force.player.toJSON()
        hits: force.getHits()
        damage: force.getDamage()
        losses: force.totalUnitsLost()

      elForce = $ elForce
      el.find(".forces").append elForce

      # Display units in force
      elUnits = elForce.find(".units")
      units = _.filter force.units, (unit) ->
        unit.getQuantityBefore() > 0

      for unit in units
        obj = unit.toJSON()
        elUnit = $ @unitTemplate(obj)
        elUnits.append elUnit
        # insert formatted rolls
        new ti3.DiceRollsView(hit: obj.battle, rolls: obj.rolls, el: elUnit.find(".rolls")).render()

      # Promotions
      promotionsText = @getPromotionsText(force)
      promotions = elForce.find('.promotions')
      if promotionsText.length
        promotions.show()
        promotions.html "<p>#{promotionsText}</p>"
        elPromotionsNotice.show()
      else
        promotions.hide()

    # end for force

    # What buttons do we have available
    button.addClass("hidden") for key, button of @conditionalButtons

    if battleFinished
      if winner? and winner.stance() is "attacker" and @model.getCombatType() is "space"
        @conditionalButtons.invasion.removeClass "hidden"
    else
      @conditionalButtons.next.removeClass "hidden"

    this

  _doneHandler: (e) ->
    e.preventDefault()
    @model.newBattle( @model.getCombatType() )

  _nextRoundHandler: (e) ->
    e.preventDefault()
    @model.resolvePromotions()
    @model.nextRound()
    @hide()

  _startInvasionCombatHandler: (e) ->
    e.preventDefault()
    @model.newBattle("ground")
    @hide()
