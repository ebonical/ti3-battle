class BattleForce extends Backbone.Model
  defaults:
    damage: 0

  initialize: ->
    @units = []

  # attacker or defender
  stance: ->
    @options.stance

  opponentStance: ->
    if @stance() is "defender" then "attacker" else "defender"

  hits: ->
    _.reduce(@units, (total, unit) ->
        total + unit.get("hits")
      , 0)

  addUnit: (theUnit, quantity = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].adjustQuantityBy(quantity)
    else
      unit = new BattleUnit(unit: theUnit, quantity: quantity)
      unit.on "change:damage", =>
        @sumDamage()
      @units.push unit

  clearUnits: ->
    for unit in @units
      unit.setQuantity(0)

  addDamage: (theUnit, damageAmount = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].damage += damageAmount

  indexOfUnit: (theUnit) ->
    found = index for unit, index in @units when unit.id is theUnit.id
    found

  # Total damage across all units
  sumDamage: ->
    @set "damage", _.reduce(@units, (total, unit) ->
        total + unit.get("damage")
      , 0)
