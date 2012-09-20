_.templateSettings =
  interpolate : /\{\{(.+?)\}\}/g

# Models
class Player extends Backbone.Model
  defaults:
    color: 'default'

  toJSON: ->
    obj = super
    obj.race = @get('race').toJSON()
    obj

class Unit extends Backbone.Model
  defaults:
    dice: 1

class Race extends Backbone.Model

class Dice
  @roll: (count = 1) ->
    while count-- > 0
      Math.floor(Math.random() * 10) + 1

# Battle has an attacking and defending player
# It should track each round.
# Space Battle phases: pre-battle anti-fighter (round 0)
class Battle extends Backbone.Model
  defaults:
    round: 1
    combatType: "space"
    resolved: false

  initialize: ->
    @attacker = new BattleForce(stance: 'attacker')
    @defender = new BattleForce(stance: 'defender')
    @setCombatType @get('combatType')

  # Roll dice for each unit in a battle force
  resolve: ->
    return if @get("resolved")
    if @attacker.player? and @defender.player?
      for force in [@attacker, @defender]
        unit.rollDice() for unit in force.units

      @setResolved true

  setResolved: (isResolved) ->
    @set "resolved", isResolved

  # Resets rolls and damage inflicted in this round
  resetRound: ->
    for force in [@attacker, @defender]
      unit.reset() for unit in force.units
    @setResolved false

  setRound: (round) ->
    round = 0 if round < 0
    @set "round", round

  setCombatType: (combatType) ->
    @set 'combatType', combatType

    conditions = switch combatType
      when 'space' then { inSpaceCombat: true }
      when 'ground' then { inGroundCombat: true }

    for unit in Units.where(conditions)
      @attacker.addUnit unit, 0
      @defender.addUnit unit, 0

  # Remove all damaged units.
  # Remember to carry damage for those that can sustain damage.
  nextRound: ->
    @setRound @get("round") + 1

  # Reset all damage points, etc
  # Perhaps a history function to rollback to previous state?
  prevRound: ->
    @setRound @get("round") - 1

  hits: ->
    {
      attacker: @attacker.hits()
      defender: @defender.hits()
    }


# One side of the Battle. Either Attacker or Defender.
class BattleForce extends Backbone.Model
  initialize: ->
    @units = []

  hits: ->
    _.reduce(@units, (total, unit) ->
        total + unit.get("hits")
      , 0)

  addUnit: (theUnit, quantity = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].adjustQuantityBy(quantity)
    else
      @units.push new BattleUnit(unit: theUnit, quantity: quantity)

  addDamage: (theUnit, damageAmount = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].damage += damageAmount

  indexOfUnit: (theUnit) ->
    found = index for unit, index in @units when unit.id is theUnit.id
    found

  opponent: ->
    if @options.stance is "defender" then "attacker" else "defender"


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

  adjustQuantityBy: (change) ->
    quantity = @get("quantity") + change
    quantity = 0 if quantity < 0
    @set "quantity", quantity

  reset: ->
    @set "hits", 0
    @set "damage", 0
    @set "rolls", []

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



# Collections
class PlayerCollection extends Backbone.Collection
  model: Player

class UnitCollection extends Backbone.Collection
  model: Unit

class RaceCollection extends Backbone.Collection
  model: Race


# Views
class AppView extends Backbone.View
  el: "body"

  events:
    "click .main-nav a[href=#battle]": "openBattleBoard"

  openBattleBoard: (e) ->
    e.preventDefault()
    $('.section.active').removeClass('active')
    $('.section#battle').addClass('active')
    @battle ?= new BattleView


class UnitListView extends Backbone.View
  tagName: "li"

  template:
    _.template "<%= name %> (<%= battle %>)"

  render: ->
    @$el.html @template(@model.toJSON())
    this


class BattleView extends Backbone.View
  el: ".section#battle"

  initialize: ->
    state.battle = new Battle(combatType: 'space')

    state.battle.on "change:round", (battleModel, round) =>
      @_setRound(battleModel, round)

    @attacker = new BattleForceView
      el: @$el.find('.attacker')
      stance: 'attacker'
      combatType: 'space'

    @defender = new BattleForceView
      el: @$el.find('.defender')
      stance: 'defender'
      combatType: 'space'

    # Get current players from view if set
    # Or start with the current player and some other player
    if @attacker.$el.data('player') is 0
      @setAttackingPlayer state.player

    if @defender.$el.data('player') is 0
      id = state.player.id + 1
      @setDefendingPlayer(Players.get(id) || Players.get(1))

  events:
    "click a[href=#resolve-battle]": "resolveBattle"

  resolveBattle: (e) ->
    e.preventDefault()
    state.battle.resolve()

  setPlayer: (side, player) ->
    state.battle[side].player = player
    @[side].setPlayer player

  setAttackingPlayer: (player) ->
    @setPlayer('attacker', player)

  setDefendingPlayer: (player) ->
    @setPlayer('defender', player)

  _setRound: (battleModel, round) ->
    el = @$el.find(".round")
    el.toggleClass("zero", round is 0)
    $(".round-number .value", el).text(round)


class BattleForceView extends Backbone.View
  initialize: ->
    @playerEl = $('h3.name', @$el)
    @playerTemplate = _.template(@playerEl.html())

    state.battle.on "change:resolved", (model, isResolved) =>
      @_setHitsFromOpponent(model, isResolved)

  setPlayer: (player) ->
    @player = player
    @$el.data('player', @player.id)
    @render()

  _setHitsFromOpponent: (model, isResolved) ->
    hits = $('.hits-from-opponent', @$el)
    hits.toggleClass 'hidden', not isResolved
    opponent = if @options.stance is "defender" then "attacker" else "defender"
    $('.value', hits).text model[opponent].hits()

  render: ->
    @$el.removeClass ->
      _this = $(this)
      klasses = _this.attr('class').split(' ')
      klasses = (klass for klass in klasses when /^(race|color)-/.test(klass)).join(' ')
      _this.removeClass klasses

    @$el.addClass "race-#{@player.get("race").id} color-#{@player.get("color")}"

    @playerEl.html @playerTemplate(@player.toJSON())


    # Units
    @units = []
    oob = @$el.find('.order-of-battle .units').html('')

    for unit in state.battle[@options.stance].units
      view = new BattleUnitView(model: unit, id: unit.cid, className: "unit zero #{unit.id}")
      oob.append view.render().el
      @units.push view

    this


class BattleUnitView extends Backbone.View
  rollHitTemplate: _.template('<span class="hit">{{value}}</span>')
  rollMissTemplate: _.template('<span class="miss">{{value}}</span>')

  template: _.template($(".order-of-battle .unit.template").html())

  initialize: ->
    @model.on "change:quantity", (model, quantity) =>
      @_setQuantity(quantity)

    @model.on "change:rolls", (model, rolls) =>
      @_setRolls(model, rolls)

  events:
    "click .increase": "increaseQuantity"
    "click .decrease": "decreaseQuantity"

  increaseQuantity: (e) ->
    e.preventDefault()
    @model.adjustQuantityBy 1

  decreaseQuantity: (e) ->
    e.preventDefault()
    @model.adjustQuantityBy -1

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

  render: ->
    @$el.html @template(@model.toJSON())
    this



# init collections
window.Units = new UnitCollection(databank.units)
window.Races = new RaceCollection(databank.races)
window.Players = new PlayerCollection [
  {id: 1, name: 'Ebony', race: Races.get('sol'), color: 'red'}
  {id: 2, name: 'Aaron', race: Races.get('norr'), color: 'blue'}
]

window.state =
  player: Players.first()
  battle: null

# init app
window.App = new AppView

