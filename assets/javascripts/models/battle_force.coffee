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
    found = unit for unit in @units when unit.id is unitId
    found

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

