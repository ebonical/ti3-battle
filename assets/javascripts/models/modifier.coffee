class window.Modifier extends Backbone.Model

  getRound: ->
    @get("round")

  getDuration: ->
    @get("duration") or (if @isInfinite() then 999 else 1)

  getModifiers: ->
    @get("modify") or {}


  isAutomatic: ->
    auto = @get("automatic")
    auto ?= true
    auto is true

  isInfinite: ->
    (@get("duration") or 0) is 0

  isForCombatType: (combatType, stance) ->
    scope = @get("scope")
    stanceRequired = @get("stance")
    isOk = scope is "combat" or scope is combatType
    if stanceRequired?
      isOk and= stance is stanceRequired
    isOk

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
    requires = @get("unitRequires")
    if requires?
      for key, value of requires
        unitValue = unit.get(key)
        if typeof value is "object"
          anyMatch = false
          for value2 in value
            anyMatch or= unitValue is value2
          isOk and= anyMatch
        else
          isOk and= unitValue is value
    isOk

