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
    @modifiers = []

    @on "change:battleValueAdjustment", => @applyModifiers
    @on "change:quantity", => @_checkSustainedDamageValue


  getBattleValue: ->
    @get "battle"

  setBattleValue: (value) ->
    value = 10 if value > 10
    value = 1 if value < 1
    @set "battle", +value

  getQuantity: ->
    @get("quantity")

  setQuantity: (quantity) ->
    quantity = 0 if quantity < 0
    quantity = 99 if quantity > 99
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
    if damage > @getMaxDamage()
      damage = @getMaxDamage()
    @set "damage", +damage

  getSustainedDamage: ->
    @get("sustainedDamage") or 0

  setSustainedDamage: (damage) ->
    if @canSustainDamage()
      damage = @getQuantity() if damage > @getQuantity()
      damage = 0 if damage < 0
    else
      damage = 0
    @set "sustainedDamage", damage

  setSafeValue: (key, value) ->
    switch key
      when "battle" then @setBattleValue(value)
      else
        fn = eval("this.set" + key.charAt(0).toUpperCase() + key.slice(1))
        if typeof fn is "function"
          fn.call(this, value)
        else
          console.warn "setSafeValue: '#{key}' no safe setter defined"
          @set(key, value)


  getDice: ->
    @get("dice")

  setDice: (dice) ->
    dice = 0 if dice < 0
    @set "dice", +dice

  getToughness: ->
    @get("toughness") or 1

  # Maximum level of damage this set of Units can take
  getMaxDamage: ->
    @getToughness() * @getQuantity() - @getSustainedDamage()


  canSustainDamage: ->
    @getToughness() > 1

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

  addModifier: (modifier) ->
    for key, value of modifier.getModifiers()
      operator = String(value).charAt(0)
      # Positive battle modifiers actually lower the battle value so invert it
      if key is "battle" and /[-+]/.test(operator)
        value = value.replace /[-+]/, (if operator is "+" then "-" else "+")
      @modifiers.push
        id: modifier.id
        key: key
        value: value

  removeModifier: (modifier) ->
    iterator = (m) -> m.id is modifier.id
    if _.find(@modifiers, iterator)?
      @undoModifiers()
      @modifiers = _.reject @modifiers, iterator
      @applyModifiers()

  # Resets all values back to base unit
  undoModifiers: ->
    for mod in @modifiers
      @setSafeValue mod.key, @unit.get(mod.key)

  clearModifiers: ->
    @undoModifiers()
    @modifiers = []

  applyModifiers: ->
    # Set up battle value from user defined modifier
    # Start with the original base value of the unit
    value = @unit.get("battle")
    value -= (@get("battleValueAdjustment") || 0)
    @setBattleValue value
    #
    for mod in @modifiers
      operator = String(mod.value).charAt(0)
      value = mod.value
      if /[-+]/.test(operator)
        value = @get(mod.key) + +value
      @setSafeValue(mod.key, value)


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
      hitpoints = @getToughness() * quantity
      remaining = (hitpoints - damage - @getSustainedDamage()) / @getToughness()
      @setSustainedDamage Math.ceil(remaining) - Math.floor(remaining)
      @setQuantity Math.ceil(remaining)

    @set "quantityBefore", quantity


  # When quantity changes make sure sustained damage doesn't exceed limits
  _checkSustainedDamageValue: ->
    if (d = @getSustainedDamage()) > 0
      @setSustainedDamage(d)


  toJSON: ->
    obj = @get("unit").toJSON()
    _.extend(obj, super)
    obj.cid = @cid
    obj.losses = @get("quantityBefore") - @getQuantity()
    obj
