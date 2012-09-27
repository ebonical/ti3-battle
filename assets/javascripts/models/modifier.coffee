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

  isForCombatType: (combatType, stance) ->
    scope = @get("scope")
    stanceRequired = @get("stance")
    (scope is "combat" or scope is "#{combatType}-combat") and
      ((not stanceRequired?) or stance is stanceRequired)

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
        isOk and= unit.get(key) is value

    isOk

