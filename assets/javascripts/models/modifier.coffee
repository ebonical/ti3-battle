class window.Modifier extends Backbone.Model

  getRound: ->
    @get("round")

  getDuration: ->
    @get("duration") or (if @isInfinite() then 999 else 1)

  getModifiers: ->
    @get("modify") or {}


  isAutomatic: ->
    @get("automatic") is true

  isInfinite: ->
    (@get("duration") or 0) is 0

  isForCombatType: (combatType) ->
    @get("scope") is "#{combatType}-combat" or @get("scope") is "combat"

  isRestrictedToRound: ->
    @get("round")?

  isForRound: (roundNumber) ->
    return true unless @isRestrictedToRound()
    startRound = @getRound()
    endRound = startRound + @getDuration()
    # within min/max bounds of duration
    roundNumber >= startRound and roundNumber < endRound

  # Match conditions of the unit
  isForUnit: (unit) ->
    isOk = true
    requires = @get("requires")
    if requires?
      for key, value of requires
        isOk and= unit.get(key) is value

    isOk

