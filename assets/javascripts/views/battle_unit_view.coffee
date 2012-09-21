class BattleUnitView extends Backbone.View

  rollHitTemplate: _.template('<span class="hit">{{value}}</span>')
  rollMissTemplate: _.template('<span class="miss">{{value}}</span>')

  template: _.template($(".order-of-battle .unit.template").html())

  initialize: ->
    @model.on "change:quantity", (model, quantity) =>
      @_setQuantity(quantity)

    @model.on "change:rolls", (model, rolls) =>
      @_setRolls(model, rolls)

    @model.on "change:battle", (model, newValue) =>
      @_setBattleValue(model, newValue)

    @model.on "change:battleValueAdjustment", (model, newValue) =>
      @_setBattleValueAdjustment(model, newValue)

    @model.on "change:damage", (model, newValue) =>
      @_setDamageValue(model, newValue)


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
    @$el.find('.quantity .value').text(quantity)

  _setRolls: (model, rolls) ->
    results = []
    for roll in rolls
      if model.hitTest(roll)
        results.push @rollHitTemplate(value: roll)
      else
        results.push @rollMissTemplate(value: roll)
    @$el.find('.rolls').html results.join(', ')

  _setBattleValue: (model, value) ->
    @$el.find(".battle-value .value").text(value)

  _setBattleValueAdjustment: (model, adjustment) ->
    text = adjustment
    text = "+" + adjustment if adjustment >= 0
    $('.adjust-battle-values .value', @$el).text(text)

  _setDamageValue: (model, value) ->
    el = @$el.find(".damage")
    el.find(".value").text value
    el.toggleClass "zero", value is 0


  render: ->
    @$el.html @template(@model.toJSON())
    this

