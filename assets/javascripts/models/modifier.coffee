class window.Modifier extends Backbone.Model

  getRound: ->
    @get("round")

  getDuration: ->
    @get("duration") or 0

  getModifiers: ->
    @get("modify") or {}


  isAutomatic: ->
    @get("automatic") is true

  isInfinite: ->
    @getDuration() is 0

  isForCombatType: (combatType) ->
    @get("scope") is "#{combatType}-combat" or @get("scope") is "combat"

  isRestrictedToRound: ->
    @getRound()?

  isForRound: (roundNumber) ->
    not @isRestrictedToRound() or @getRound() is roundNumber

  # Match conditions of the unit
  isForUnit: (unit) ->
    isOk = true
    requires = @get("requires")
    if requires?
      for key, value of requires
        isOk and= unit.get(key) is value

    isOk

