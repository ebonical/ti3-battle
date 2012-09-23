# Battle has an attacking and defending player
# It should track each round.
# Space Battle phases: pre-battle anti-fighter (round 0)
class Battle extends Backbone.Model
  defaults:
    round: 1
    combatType: "space"
    diceRolled: false
    roundResolved: false

  initialize: ->
    @attacker = new BattleForce(stance: 'attacker', battle: this)
    @defender = new BattleForce(stance: 'defender', battle: this)
    @setCombatType @get('combatType')

  # Roll dice for each unit in a battle force
  # TODO check that at least one unit is on each side
  rollDice: ->
    return if @get("diceRolled")
    if @attacker.player? and @defender.player?
      for force in [@attacker, @defender]
        unit.rollDice() for unit in force.units

      @setDiceRolled true

  # Reset all dice rolled and damage set in this round
  resetDice: ->
    if @get "diceRolled"
      for force in [@attacker, @defender]
        unit.reset() for unit in force.units
      @setDiceRolled false

  setDiceRolled: (isRolled) ->
    @set "diceRolled", isRolled

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

  # Are there any forces left in the battle?
  finished: ->
    zeroAttackers = @attacker.totalNumberOfUnits() is 0
    zeroDefenders = @defender.totalNumberOfUnits() is 0
    @get("roundResolved") and (zeroAttackers or zeroDefenders)

  winner: ->
    attackersRemain = @attacker.totalNumberOfUnits() > 0
    defendersRemain = @defender.totalNumberOfUnits() > 0
    if attackersRemain and not defendersRemain
      @attacker
    else if defendersRemain and not attackersRemain
      @defender

  # Resolve all damage applied to units
  resolveDamage: ->
    @attacker.resolveDamage()
    @defender.resolveDamage()
    @set "roundResolved", true
