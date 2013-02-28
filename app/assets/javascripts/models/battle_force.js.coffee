# gets passed id: and battle:
# @attributes.battle
class ti3.BattleForce extends Backbone.Model
  defaults:
    totalNumberOfUnits: 0
    damage: 0

  initialize: ->
    @units = []
    # When round changes we need to expire old modifiers and apply new ones
    @attributes.battle.on "change:round", (model, newValue) =>
      @expireModifiers()
      @applyModifiers()

    if state.game?
      for player in state.game.players
        player.on "change:technologies", (model, technologies) =>
          if model.getNumber() is @player.getNumber()
            @expireModifiers(true)
            @fetchModifiers @attributes.battle.getCombatType()
            @applyModifiers()


  setPlayer: (player) ->
    @player = player
    @resetModifiers(@attributes.battle.getCombatType())
    @set "player", player

  reset: ->
    @units = []
    @_setActiveModifiers []
    @sumQuantity()
    @sumDamage()

  getDamage: ->
    @get("damage") or 0

  # attacker or defender
  stance: ->
    @id

  oppositeStance: ->
    if @stance() is "defender" then "attacker" else "defender"

  opponent: ->
    @attributes.battle[@oppositeStance()]

  getHits: ->
    _.reduce(@units, (total, unit) ->
        total + unit.getHits()
      , 0)

  addUnit: (theUnit, quantity = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].adjustQuantityBy(quantity)
    else
      unit = new ti3.BattleUnit(unit: theUnit, quantity: quantity, force: this)
      unit.on "change:quantity", => @sumQuantity()
      unit.on "change:damage", => @sumDamage()
      @units.push unit

  clearUnits: ->
    for unit in @units
      unit.setQuantity(0)

  addDamage: (theUnit, damageAmount = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].damage += damageAmount

  resolveDamage: ->
    unit.resolveDamage() for unit in @units

  getUnit: (unitId) ->
    @getUnits(unitId)[0]

  getUnits: (unitIds...) ->
    _.filter @units, (unit) ->
      _.include(unitIds, unit.id)

  getUnitsWith: (conditions) ->
    _.filter @units, (unit) ->
      results = for key, value of conditions
        if key is "hasUnits"
          if value then unit.hasUnits() else not unit.hasUnits()
        else if _.isObject(value)
          eval "#{unit.get(key)} #{value.operator} #{value.value}"
        else
          unit.get(key) is value
      _.all(results, _.identity)

  indexOfUnit: (theUnit) ->
    found = index for unit, index in @units when unit.id is theUnit.id
    found

  sumQuantity: ->
    @set "totalNumberOfUnits", _.reduce(@units, (total, unit) ->
        total + unit.getQuantity()
      , 0)

  # Total damage across all units
  sumDamage: ->
    @set "damage", _.reduce(@units, (total, unit) ->
        total + unit.getDamage()
      , 0)

  totalNumberOfUnits: ->
    @get("totalNumberOfUnits") or 0

  totalNumberOfUnitsBefore: ->
    _.reduce(@units, (total, unit) ->
        total + unit.getQuantityBefore()
      , 0)

  totalUnitsLost: ->
    total = @totalNumberOfUnitsBefore() - @totalNumberOfUnits()
    if total < 0 then 0 else total

  # Retrieve all modifiers that could be relevant to player and current units
  fetchModifiers: (combatType) ->
    stance = @stance()
    # Start with global modifiers
    @modifiers = [].concat ti3.GlobalModifiers.models

    if @player?
      # Racial abilities
      @modifiers = @modifiers.concat @player.race.getModifiers()
      # Technologies
      @modifiers = @modifiers.concat @player.getTechnologyModifiers()

    # Get rid of modifiers that don't match combat type
    @modifiers = _.filter @modifiers, (m) ->
      m.isForCombatType(combatType, stance)

    # Send modifiers off to opponent if needed
    @modifiersForOpponent = []
    for m in @modifiers when m.modifiesOpponent()
      @modifiersForOpponent.push m.cloneForOpponent()

  applyModifiers: ->
    @_setActiveModifiers(@activeModifiers)
    round = @attributes.battle.getRound()
    @applyModifiersFromOpponent(@opponent())
    activeIds = _.map @activeModifiers, (obj) -> obj.id

    for mod in @modifiers.concat()
      modAdded = false
      if (not _.include(activeIds, mod.id)) and (mod.isAutomatic() or @isModifierOn(mod)) and mod.isForRound(round)
        for unit in @units
          if mod.isForUnit(unit)
            unit.addModifier(mod)
            modAdded = true
        if modAdded
          @activeModifiers.push
            id: mod.id
            round: round
            modifier: mod
    # After all modifiers have been added then apply them
    unit.applyModifiers() for unit in @units
    @_setActiveModifiers(@activeModifiers)

  # Check active modifiers and remove if necessary
  # Clear all unit modifiers and reapply
  expireModifiers: (expireAll = false) ->
    @_setActiveModifiers(@activeModifiers)
    round = @attributes.battle.getRound()
    for active in @activeModifiers
      mod = active.modifier
      if expireAll
        active.expired = true
      else if not mod.isForRound(round)
        active.expired = true
      else if not mod.isInfinite()
        # if it has a duration and that has passed : expire
        roundDelta = Math.abs round - active.round
        if roundDelta >= mod.getDuration()
          active.expired = true
    # Remove expired modifiers
    @_setActiveModifiers _.reject @activeModifiers, (aMod) =>
      if aMod.expired
        unit.removeModifier(aMod) for unit in @units
        true

  # Manually adds a modifier that isn't applied automatically
  addModifier: (modifier) ->
    found = _.find @modifiers, (m) -> m.id is modifier.id
    @modifiers.push(modifier) unless found?
    @turnOnModifier modifier

  turnOnModifier: (modifier) ->
    @optionalModifiersTurnedOn ?= []
    unless _.include(@optionalModifiersTurnedOn, modifier.id)
      @optionalModifiersTurnedOn.push modifier.id
      @applyModifiers()

  isModifierOn: (modifier) ->
    _.include(@optionalModifiersTurnedOn, modifier.id)

  hasModifiersForOpponent: ->
    (@modifiersForOpponent or []).length > 0

  applyModifiersFromOpponent: (opponent) ->
    @modifiersFromOpponent ?= []
    # Reverse effects of all existing modifiers from opponent
    for mod in @modifiersFromOpponent
      unit.removeModifier(mod) for unit in @units
      ids = _.map @modifiersFromOpponent, (m) -> m.id
      @modifiers = _.reject @modifiers, (m) -> _.include(ids, m.id)
      @_setActiveModifiers _.reject(@activeModifiers, (m) -> _.include(ids, m.id))
    # Apply new modifiers
    if opponent.hasModifiersForOpponent()
      @modifiersFromOpponent = [].concat opponent.modifiersForOpponent
      @modifiers = @modifiers.concat @modifiersFromOpponent
      # @applyModifiers()

  resetModifiers: (combatType) ->
    @_setActiveModifiers []
    @optionalModifiersTurnedOn = []
    @modifiersFromOpponent = []
    unit.clearModifiers() for unit in @units
    @fetchModifiers(combatType)
    @applyModifiers()

  _setActiveModifiers: (activeModifiersArray) ->
    @activeModifiers = activeModifiersArray or []
    @set 'activeModifiers', _.map(@activeModifiers, (m) -> m.id).join(',')

