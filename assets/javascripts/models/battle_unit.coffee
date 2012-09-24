# A group of the same type units in a battle force
class BattleUnit extends Backbone.Model
  defaults:
    hits: 0
    damage: 0
    quantity: 0
    toughness: 1
    rolls: []


  initialize: ->
    @unit = @get "unit"
    @set(key, value) for key, value of @unit.attributes

    @on "change:battleValueAdjustment", => @applyModifiers


  getBattleValue: ->
    @get "battle"

  setBattleValue: (value) ->
    value = 10 if value > 10
    value = 1 if value < 1
    @set "battle", value

  getQuantity: ->
    @get("quantity")

  setQuantity: (quantity) ->
    quantity = 0 if quantity < 0
    @set "quantity", quantity

  getQuantityBefore: ->
    @get("quantityBefore") or @getQuantity()

  getHits: ->
    @get("hits") or 0

  getDamage: ->
    @get("damage") or 0

  setDamage: (damage) ->
    if damage < 0 or @getQuantity() is 0
      damage = 0
    @set "damage", damage

  getDice: ->
    @get("dice")


  canBombard: ->
    @get("bombard") is true

  canIgnorePds: ->
    @get("ignorePds") is true


  hasUnits: ->
    @getQuantity() > 0

  adjustQuantityBy: (change) ->
    quantity = @getQuantity() + change
    @setQuantity quantity

  adjustBattleValueBy: (change) ->
    adjustment = (@get("battleValueAdjustment") || 0) + change
    if Math.abs(adjustment) > 5
      adjustment = 5 * (if change < 0 then -1 else 1)
    @set "battleValueAdjustment", adjustment

  adjustDamageBy: (change) ->
    @setDamage @getDamage() + change

  clearDamage: ->
    @setDamage 0

  reset: ->
    @set "hits", 0
    @set "damage", 0
    @set "rolls", []

  applyModifiers: ->
    # Start with the original base value of the unit
    value = @unit.get("battle")
    # Get user-defined mofifier (from interface)
    value -= (@get("battleValueAdjustment") || 0)
    @setBattleValue value

  rollDice: ->
    @setDiceRolls Dice.roll(@getQuantity() * @getDice())

  setDiceRolls: (rolls) ->
    hits = 0
    hits++ for result in rolls when @hitTest(result)
    @set "rolls", rolls
    @set "hits", hits

  hitTest: (value) ->
    value >= @getBattleValue()

  # After dice have been rolled and damage has been attached to each unit group
  # then reduce quantities by damage level applied
  resolveDamage: ->
    damage =  @getDamage()
    quantity = @getQuantity()

    unless damage is 0 or quantity is 0
      # can unit sustain damage? (hitpoints)
      hitpoints = @get("toughness") * quantity
      remaining = Math.ceil((hitpoints - damage) / @get("toughness"))
      @setQuantity remaining

    @set "quantityBefore", quantity



  toJSON: ->
    obj = @get("unit").toJSON()
    _.extend(obj, super)
    obj.cid = @cid
    obj.losses = @get("quantityBefore") - @getQuantity()
    obj
