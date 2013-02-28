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
class ti3.Battle extends Backbone.Model
  defaults:
    round: 1
    combatType: "space"
    diceRolled: false
    roundResolved: false

  initialize: ->
    @attacker = new ti3.BattleForce(id: "attacker", battle: this)
    @defender = new ti3.BattleForce(id: "defender", battle: this)

    for force in [@attacker, @defender]
      force.on "change:totalNumberOfUnits", (model, newValue) =>
        @_togglePreRoundCombat(model, newValue)

      force.on "change:player", (model, newValue) =>
        @_forcePlayerHasChanged(model, newValue)

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

    for force in [@attacker, @defender]
      force.reset()

      for unit in ti3.Units.where(conditions)
        if state.game.usingExpansion(unit.getExpansion())
          force.addUnit unit, 0

      force.resetModifiers(combatType)

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
    _.delay(() =>
        @set "newBattle", false
      , 1000)

  # Roll dice for each unit in a battle force
  # TODO check that at least one unit is on each side
  rollDice: ->
    return if @get("diceRolled")

    switch @getCombatType()
      when "space"
        if @getRound() is 0
          @_rollPreSpaceCombatDice()
        else
          @_rollSpaceCombatDice()

      when "ground"
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

  # Pre-combat for Space Battles
  # Currently only implements Anti-Fighter Barrage
  _rollPreSpaceCombatDice: ->
    # units with antifighter apply damage to opposing fighters
    for force in [@attacker, @defender]
      opposite = @[force.oppositeStance()]

      ships = force.getUnitsWith
        antifighter: true
        hasUnits: true

      fighters = opposite.getUnitsWith
        id: "fighter"
        hasUnits: true

      if ships.length > 0 and fighters.length > 0
        for ship in ships
          # TODO apply anti-fighter barrage modifier
          ship.rollDice()
          fighters[0].adjustDamageBy ship.getHits()

  # Standard Invasion Combat - only Ground Forces
  # Automatically apply damage to each other's Ground Forces
  _rollGroundCombatDice: ->
    units = {}
    for force in [@attacker, @defender]
      units[force.id] = force.getUnitsWith
        activeGroundCombatUnit: true
        hasUnits: true

      units[force.id].totalHits = 0
      for unit in units[force.id]
        unit.rollDice()
        units[force.id].totalHits += unit.getHits()

    # auto-apply damage when a side has only 1 unit type
    if units.attacker.length == 1
      units.attacker[0].adjustDamageBy units.defender.totalHits

    if units.defender.length == 1
      units.defender[0].adjustDamageBy units.attacker.totalHits

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
      totalHits = 0
      for unit in units
        unit.rollDice()
        totalHits += unit.getHits()

      # If we're only applying to 1 active ground force type
      groundForces = @defender.getUnitsWith hasUnits: true, activeGroundCombatUnit: true
      if groundForces.length == 1
        groundForces[0].adjustDamageBy totalHits

    # PDS Fire - damages ATTACKING Ground Forces & Shock Troops
    if @preCombatPhases.pdsFire
      pds = @defender.getUnit("pds")
      pds.rollDice()

      groundForces = @attacker.getUnitsWith hasUnits: true, activeGroundCombatUnit: true
      if groundForces.length == 1
        groundForces[0].adjustDamageBy pds.getHits()

  # If player A changes then it sends its own modifiers to opponent
  # they must also check if opponent has modifiers for them too
  _forcePlayerHasChanged: (force, newPlayer) ->
    force.applyModifiers()
    @[force.oppositeStance()].applyModifiers()

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
    @resolvingDamage = true
    @attacker.resolveDamage()
    @defender.resolveDamage()
    @resolvingDamage = false
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
      units = force.getUnitsWith antifighter: true, hasUnits: true
      test[force.id].hasAntiFighter = units.length > 0

      units = force.getUnitsWith id: "fighter", hasUnits: true
      test[force.id].hasFighters = units.length > 0

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
      # Does the force have any active ground units?
      units = force.getUnitsWith hasUnits: true, activeGroundCombatUnit: true
      test[force.id].hasGroundForces = units.length > 0

      if force.id is "attacker"
        # 2. Bombard
        units = force.getUnitsWith hasUnits: true, bombard: true
        test[force.id].hasBombard = units.length > 0

        # 2b. Ignoring PDS defense
        if test[force.id].hasBombard
          units = force.getUnitsWith hasUnits: true, ignorePds: true
          test[force.id].hasIgnorePds = units.length > 0

      if force.id is "defender"
        # 1. PDS fire
        units = force.getUnitsWith hasUnits: true, id: "pds"
        test[force.id].hasPds = units.length > 0

    # If defender has PDS then attacker must be able to ignore it
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
    return if @resolvingDamage
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
