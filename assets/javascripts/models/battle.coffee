# Battle has an attacking and defending player
#
# Space Battle sequence
#   Set unit quantities and adjust any battle values and apply sustained damage
#   Roll Dice
#   Apply damage from any hits
#   Resolve damage showing summary of round
#
# Invasion Combat sequence
#   Set unit quantities and adjust battle values etc.
#   Roll only for Ground Forces
#   Follow Roll Dice above
#
class Battle extends Backbone.Model
  defaults:
    round: 1
    combatType: "space"
    diceRolled: false
    roundResolved: false

  initialize: ->
    @attacker = new BattleForce(id: "attacker", battle: this)
    @defender = new BattleForce(id: "defender", battle: this)

    @attacker.on "change:totalNumberOfUnits", (model, newValue) =>
      @_togglePreRoundCombat(model, newValue)
    @defender.on "change:totalNumberOfUnits", (model, newValue) =>
      @_togglePreRoundCombat(model, newValue)


    @setCombatType @getCombatType()


  getRound: ->
    @get("round")

  setRound: (round) ->
    round = 0 if round < 0
    @set "roundResolved", false
    @set "round", round

  getCombatType: ->
    @get("combatType") or "space"

  setCombatType: (combatType) ->
    conditions = switch combatType
      when 'space' then { inSpaceCombat: true }
      when 'ground' then { inGroundCombat: true }

    @attacker.reset()
    @defender.reset()

    for unit in Units.where(conditions)
      @attacker.addUnit unit, 0
      @defender.addUnit unit, 0

    @set "newBattle", false
    @set "combatType", combatType


  # Start a fresh battle
  # Setting combat type "space" or "ground"
  # Clear both side's units and re-initialize them
  # Reset round number
  newBattle: (combatType = "space") ->
    @preCombatResolved = false
    @setRound 1
    @setDiceRolled false
    @setCombatType combatType
    @set "newBattle", true

  # Roll dice for each unit in a battle force
  # TODO check that at least one unit is on each side
  rollDice: ->
    return if @get("diceRolled")

    if @getCombatType() is "space"
      @_rollSpaceCombatDice()

    else if @getCombatType() is "ground"
      if @getRound() is 0
        @_rollPreGroundCombatDice()
      else
        @_rollGroundCombatDice()

    @setDiceRolled true

  # Standard Space Battle
  # TODO automatically apply damage to ships when outcome is clear
  _rollSpaceCombatDice: ->
    for force in [@attacker, @defender]
      unit.rollDice() for unit in force.units

  # Standard Invasion Combat - only Ground Forces
  # Automatically apply damage to each other's Ground Forces
  _rollGroundCombatDice: ->
    attackingGroundForce = @attacker.getUnit("ground")
    defendingGroundForce = @defender.getUnit("ground")

    attackingGroundForce.rollDice()
    defendingGroundForce.rollDice()

    attackingGroundForce.adjustDamageBy defendingGroundForce.getHits()
    defendingGroundForce.adjustDamageBy attackingGroundForce.getHits()

  # Pre-combat round for Invasion
  # Bombardment applies damage to defending Ground Forces
  # PDS fire from defender inflicts damage on invading Ground Forces
  _rollPreGroundCombatDice: ->
    # Bombardment - check if we need the ignore PDS ability
    if @preCombatPhases.bombardment
      mustIgnorePds = @preCombatPhases.pdsFire
      units = _.filter @attacker.units, (unit) ->
        unit.hasUnits() and unit.canBombard() and (not mustIgnorePds or unit.canIgnorePds())
      # Roll dice for each ship that can bombard and apply any hits to defending Ground Forces
      groundForces = @defender.getUnit("ground")
      for unit in units
        unit.rollDice()
        groundForces.adjustDamageBy unit.getHits()

    # PDS Fire - damages attacking Ground Forces
    if @preCombatPhases.pdsFire
      pds = @defender.getUnit("pds")
      pds.rollDice()
      @attacker.getUnit("ground").adjustDamageBy pds.getHits()


  # Reset all dice rolled and damage set in this round
  resetDice: ->
    if @get "diceRolled"
      for force in [@attacker, @defender]
        unit.reset() for unit in force.units
      @setDiceRolled false

  setDiceRolled: (isRolled) ->
    @set "diceRolled", isRolled

  # Remove all damaged units.
  # Remember to carry damage for those that can sustain damage.
  nextRound: ->
    @resetDice()
    if @getRound() is 0
      @preCombatResolved = true
    @setRound @getRound() + 1

  # Reset all damage points, etc
  # Perhaps a history function to rollback to previous state?
  prevRound: ->
    @setRound @getRound() - 1

  hits: ->
    {
      attacker: @attacker.getHits()
      defender: @defender.getHits()
    }

  # Are there any forces left in the battle?
  isFinished: ->
    return false unless @get("roundResolved")
    switch @getCombatType()
      when "space"
        zeroAttackers = @attacker.totalNumberOfUnits() is 0
        zeroDefenders = @defender.totalNumberOfUnits() is 0
      when "ground"
        zeroAttackers = not @attacker.getUnit("ground").hasUnits()
        zeroDefenders = not @defender.getUnit("ground").hasUnits()

    zeroAttackers or zeroDefenders

  winner: ->
    switch @getCombatType()
      when "space"
        attackersRemain = @attacker.totalNumberOfUnits() > 0
        defendersRemain = @defender.totalNumberOfUnits() > 0
      when "ground"
        attackersRemain = @attacker.getUnit("ground").hasUnits()
        defendersRemain = @defender.getUnit("ground").hasUnits()

    if attackersRemain and not defendersRemain
      @attacker
    else if defendersRemain and not attackersRemain
      @defender

  # Resolve all damage applied to units
  resolveDamage: ->
    @attacker.resolveDamage()
    @defender.resolveDamage()
    @set "roundResolved", true

  hasPreCombat: (combatType) ->
    if combatType is "ground" then @hasPreGroundCombat() else @hasPreSpaceCombat()

  # Determine if we need a round 0 of pre-combat in Space Battle.
  # 1. Fighters exist and other side has "Anti-Fighter Barrage" ability
  hasPreSpaceCombat: ->
    doIt = false
    return false if @getCombatType() != "space" or @preCombatResolved

    test = attacker: {}, defender: {}

    for force in [@attacker, @defender]
      # Antifighter ability
      test[force.id].hasAntiFighter = _.any force.units, (unit) ->
        unit.get("antifighter") and unit.hasUnits()

      test[force.id].hasFighters = _.any @attacker.units, (unit) ->
        unit.id is "fighter" and unit.hasUnits()

    doIt or= test.attacker.hasAntiFighter and test.defender.hasFighters
    doIt or= test.defender.hasAntiFighter and test.attacker.hasFighters

    doIt

  # Is there a pre-combat round for Invasion Combat
  # 1. Defender has PDS and attacker has Ground Forces
  # 2. Attacker has unit with Bombard ability and defender has Ground Forces
  hasPreGroundCombat: ->
    doIt = false
    return false if @getCombatType() != "ground" or @preCombatResolved

    test = attacker: {}, defender: {}

    for force in [@attacker, @defender]
      test[force.id].hasGroundForces = _.any force.units, (unit) ->
        unit.id is "ground" and unit.hasUnits()

      if force.id is "attacker"
        # 2. Bombard
        test[force.id].hasBombard = _.any force.units, (unit) ->
          unit.canBombard() and unit.hasUnits()

        if test[force.id].hasBombard
          test[force.id].hasIgnorePds = _.any force.units, (unit) ->
            unit.canIgnorePds() and unit.hasUnits()

      if force.id is "defender"
        # 1. PDS fire
        test[force.id].hasPds = _.any force.units, (unit) ->
          unit.id is "pds" and unit.hasUnits()

    # Check that if Defender has PDS then Attacker can still bombard
    if test.defender.hasPds and test.attacker.hasBombard
      test.attacker.hasBombard = test.attacker.hasIgnorePds

    @preCombatPhases =
      pdsFire: test.defender.hasPds and test.attacker.hasGroundForces
      bombardment: test.attacker.hasBombard and test.defender.hasGroundForces

    doIt or= value for key, value of @preCombatPhases
    doIt

  # Switch to pre-combat round 0 if...
  #   Round is 1
  #   and We haven't already resolved all pre-combat
  #   and Quantity is not 0
  #   and Test for pre-combat passes
  # Switch back to Round 1 if...
  #   Round is 0 AND
  #   Quantity becomes zero
  #   or Test for pre-combat fails
  _togglePreRoundCombat: (force, quantity) ->
    if @getRound() is 1
      doIt = not @get("preCombatResolved")
      doIt and= quantity > 0
      doIt and= @hasPreCombat @getCombatType()
      if doIt
        @setRound 0
    else if @getRound() is 0
      doIt = quantity is 0
      doIt or= not @hasPreCombat @getCombatType()
      if doIt
        @setRound 1
