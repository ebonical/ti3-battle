# gets passed id: and battle:
# @attributes.battle
class BattleForce extends Backbone.Model
  defaults:
    totalNumberOfUnits: 0
    damage: 0

  initialize: ->
    @units = []

  reset: ->
    @units = []
    @sumQuantity()
    @sumDamage()

  getDamage: ->
    @get("damage") or 0

  # attacker or defender
  stance: ->
    @id

  oppositeStance: ->
    if @stance() is "defender" then "attacker" else "defender"

  getHits: ->
    _.reduce(@units, (total, unit) ->
        total + unit.getHits()
      , 0)

  addUnit: (theUnit, quantity = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].adjustQuantityBy(quantity)
    else
      unit = new BattleUnit(unit: theUnit, quantity: quantity, force: this)
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
        else if typeof value is "object"
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
  fetchModifiers: ->
    @modifiers = []
    combatType = @attributes.battle.getCombatType()
    # Global modifiers
    @modifiers = @modifiers.concat GlobalModifiers.models
    # Race abilities
    if @player?
      @modifiers = @modifiers.concat _.filter @player.race.getModifiers(), (mod) ->
        console.log mod
        mod.isForCombatType(combatType)
    # Technologies
    # ...

  applyModifiers: ->
    round = @attributes.battle.getRound()
    # include global modifiers
    @activeModifiers ?= []
    activeIds = _.invoke @activeModifiers, "get", "id"

    for mod in @modifiers.concat()
      modAdded = false
      if not _.include(activeIds, mod.id) and mod.isAutomatic() and mod.isForRound(round)
        for unit in @units
          if mod.isForUnit(unit)
            unit.addModifier(mod)
            modAdded = true
        if modAdded
          @activeModifiers.push mod
    # After all modifiers have been added then apply them
    unit.applyModifiers() for unit in @units
