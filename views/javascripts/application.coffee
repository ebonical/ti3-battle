_.templateSettings =
  interpolate : /\{\{(.+?)\}\}/g

# Models
class Player extends Backbone.Model
  defaults:
    color: 'default'

  toJSON: ->
    json = super
    json.race = @get('race').toJSON()
    json

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
class window.Battle extends Backbone.Model
  defaults:
    round: 0
    combatType: "space"

  initialize: ->
    @attacker = new BattleForce
    @defender = new BattleForce
    @setCombatType @get('combatType')

  # Roll dice for each unit in a battle force
  resolve: ->
    if @attacker.player? and @defender.player?
      for force in [@attacker, @defender]
        unit.rollDice() for unit in force.units

  # Resets rolls and damage inflicted in this round
  resetRound: ->
    for force in [@attacker, @defender]
      unit.reset() for unit in force.units

  setRound: (round) ->
    round = 0 if round < 0
    @round = round

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
    setRound @round + 1

  # Reset all damage points, etc
  # Perhaps a history function to rollback to previous state?
  prevRound: ->
    @round = 1 if @round is 0
    setRound @round - 1


# One side of the Battle. Either Attacker or Defender.
class BattleForce extends Backbone.Model
  initialize: ->
    @units = []

  hits: ->
    _.reduce(@units, (total, unit) ->
        total + unit.hits
      , 0)

  addUnit: (theUnit, quantity = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].adjustQuantity(quantity)
    else
      @units.push new BattleUnit(unit: theUnit, quantity: quantity)

  addDamage: (theUnit, damageAmount = 1) ->
    index = @indexOfUnit(theUnit)
    if index?
      @units[index].damage += damageAmount

  indexOfUnit: (theUnit) ->
    found = index for unit, index in @units when unit.id is theUnit.id
    found


# Proxy class for units in battle
class window.BattleUnit extends Backbone.Model
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

  adjustQuantity: (change) ->
    quantity = @get("quantity") + change
    @set "quantity", quantity

  reset: ->
    @set "hits", 0
    @set "damage", 0
    @set "rolls", []

  rollDice: ->
    @setDiceRolls Dice.roll(@get("quantity") * @unit.get("dice"))

  setDiceRolls: (rolls) ->
    hits = 0
    hits++ for result in rolls when result >= @get("battle")
    @set "rolls", rolls
    @set "hits", hits

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


class window.BattleView extends Backbone.View
  el: ".section#battle"

  initialize: ->
    state.battle = new Battle(combatType: 'space')

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

  setPlayer: (side, player) ->
    state.battle[side].player = player
    @[side].setPlayer player

  setAttackingPlayer: (player) ->
    @setPlayer('attacker', player)

  setDefendingPlayer: (player) ->
    @setPlayer('defender', player)



class BattleForceView extends Backbone.View
  initialize: ->
    @playerEl = $('h3.name', @$el)
    @playerTemplate = _.template(@playerEl.html())

  setPlayer: (player) ->
    @player = player
    @$el.data('player', @player.id)
    @render()

  render: ->
    @$el.removeClass ->
      _this = $(this)
      klasses = _this.attr('class').split(' ')
      klasses = (klass for klass in klasses when /^(race|color)-/.test(klass)).join(' ')
      _this.removeClass klasses

    @$el.addClass "race-#{@player.get("race").id} color-#{@player.get("color")}"

    @playerEl.html @playerTemplate(@player.toJSON())


    # Units
    oob = @$el.find('.order-of-battle .units').html('')

    for unit in state.battle[@options.stance].units
      view = new BattleUnitView(model: unit)
      oob.append view.render().el

    this


class window.BattleUnitView extends Backbone.View
  template: _.template($('.section#battle .units').html())

  # initialize: ->

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
