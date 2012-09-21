# Proxy class for units in battle
class BattleUnit extends Backbone.Model
  defaults:
    hits: 0
    damage: 0
    quantity: 0
    rolls: []

  initialize: ->
    @unit = @get "unit"
    @set "id", @unit.id
    @set "battle", @unit.get("battle")
    @reset()

    @on "change:battleValueAdjustment", @applyModifiers

  setBattleValue: (value) ->
    value = 10 if value > 10
    value = 1 if value < 1
    @set "battle", value

  setQuantity: (quantity) ->
    @set "quantity", quantity

  adjustQuantityBy: (change) ->
    quantity = @get("quantity") + change
    quantity = 0 if quantity < 0
    @setQuantity quantity

  adjustBattleValueBy: (change) ->
    adjustment = (@get("battleValueAdjustment") || 0) + change
    if Math.abs(adjustment) > 5
      adjustment = 5 * (if change < 0 then -1 else 1)
    @set "battleValueAdjustment", adjustment

  reset: ->
    @set "hits", 0
    @set "damage", 0
    @set "rolls", []

  applyModifiers: ->
    value = @unit.get("battle")
    # Get user-defined mofifier (from interface)
    value -= (@get("battleValueAdjustment") || 0)
    @setBattleValue value

  rollDice: ->
    @setDiceRolls Dice.roll(@get("quantity") * @unit.get("dice"))

  setDiceRolls: (rolls) ->
    hits = 0
    hits++ for result in rolls when @hitTest(result)
    @set "rolls", rolls
    @set "hits", hits

  hitTest: (value) ->
    value >= @get("battle")

  toJSON: ->
    obj = @get("unit").toJSON()
    _.extend(obj, super)
    obj.cid = @cid
    obj
