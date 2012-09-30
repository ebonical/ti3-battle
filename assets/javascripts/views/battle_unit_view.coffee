class BattleUnitView extends Backbone.View

  rollHitTemplate: _.template('<span class="hit">{{value}}</span>')
  rollMissTemplate: _.template('<span class="miss">{{value}}</span>')

  template: _.template $(".order-of-battle .unit.template").html()

  initialize: ->
    @model.on "change:quantity", (model, quantity) =>
      @_setQuantity(quantity)

    @model.on "change:rolls", (model, rolls) =>
      @_setRolls(model, rolls)

    @model.on "change:battle", (model, newValue) =>
      @_setBattleValue(newValue)

    @model.on "change:dice", (model, newValue) =>
      @_setDiceCount(newValue)

    @model.on "change:battleValueAdjustment", (model, newValue) =>
      @_setBattleValueAdjustment(model, newValue)

    @model.on "change:damage", (model, newValue) =>
      @_setDamageValue(model, newValue)

    state.battle.on "change:diceRolled", (model, newValue) =>
      @_setDiceHaveBeenRolled(newValue)



  events:
    "click a[href=#increase-quantity]": "increaseQuantityHandler"
    "click a[href=#decrease-quantity]": "decreaseQuantityHandler"
    "click a[href=#increase-battle-value]": "increaseBattleValueHandler"
    "click a[href=#decrease-battle-value]": "decreaseBattleValueHandler"
    "click a[href=#add-damage]": "addDamageHandler"


  increaseQuantityHandler: (e) ->
    e.preventDefault()
    @model.adjustQuantityBy 1

  decreaseQuantityHandler: (e) ->
    e.preventDefault()
    @model.adjustQuantityBy -1

  increaseBattleValueHandler: (e) ->
    e.preventDefault()
    @model.adjustBattleValueBy 1

  decreaseBattleValueHandler: (e) ->
    e.preventDefault()
    @model.adjustBattleValueBy -1

  addDamageHandler: (e) ->
    e.preventDefault()
    @model.adjustDamageBy 1


  _setQuantity: (quantity) ->
    @$el.toggleClass("zero", quantity is 0)
    elQty = @$el.find(".quantity")
    elQty.find(".value").text quantity
    elQty.toggleClass "double", quantity > 9

  _setRolls: (model, rolls) ->
    new DiceRollsView(hit: model.getBattleValue(), rolls: rolls, el: @$el.find(".rolls")).render()

  _setBattleValue: (value) ->
    @$el.find(".battle .value").text(value)

  _setDiceCount: (value) ->
    elDice = @$el.find(".dice")
    elDice.removeClass ->
      _.filter $(this).attr('class').split(' '), (klass) ->
        /^dice-\d/.test(klass)
    elDice.addClass "dice-#{value}"
    elDice.find(".value").text(value)

  _setBattleValueAdjustment: (model, adjustment) ->
    text = adjustment
    text = "+" + adjustment if adjustment >= 0
    el = @$el.find(".adjust-battle-values")
    el.toggleClass "positive", adjustment > 0
    el.toggleClass "negative", adjustment < 0
    el.find(".value").text text

  _setDamageValue: (model, value) ->
    el = @$el.find(".damage")
    el.find(".value").text value
    el.toggleClass "zero", value is 0

  _setDiceHaveBeenRolled: (isRolled) ->
    @$el.find(".quantity a").toggleClass "disabled", isRolled


  render: ->
    @$el.html @template(@model.toJSON())
    this

