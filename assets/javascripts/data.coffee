Data =
  expansions: [
    {
      id: "se"
      name: "Shattered Empire"
    }
  ]

  units: [
    {
      id: "warsun"
      name: "War Sun"
      cost: 12
      battle: 3
      move: 2
      dice: 3
      bombard: true
      capacity: 6
      toughness: 2
      notes: "Bombardment*, Capacity: 6, Sustain Damage"
      inSpaceCombat: true
      inGroundCombat: true
      ignorePds: true
    }
    {
      id: "dreadnought"
      name: "Dreadnought"
      cost: 5
      battle: 5
      move: 1
      bombard: true
      toughness: 2
      notes: "Bombardment, Sustain Damage"
      inSpaceCombat: true
      inGroundCombat: true
    }
    {
      id: "cruiser"
      name: "Cruiser"
      cost: 2
      battle: 7
      move: 2
      inSpaceCombat: true
      inGroundCombat: false
    }
    {
      id: "destroyer"
      name: "Destroyer"
      cost: 1
      battle: 9
      move: 2
      antifighter: true
      notes: "Anti-Fighter Barrage"
      inSpaceCombat: true
      inGroundCombat: false
    }
    {
      id: "fighter"
      name: "Fighter"
      cost: 1
      battle: 9
      move: 0
      inSpaceCombat: true
      inGroundCombat: false
    }
    {
      id: "carrier"
      name: "Carrier"
      cost: 3
      battle: 9
      move: 1
      capacity: 6
      notes: "Capacity: 6"
      inSpaceCombat: true
      inGroundCombat: false
    }
    {
      id: "ground"
      name: "Ground Force"
      cost: 1
      battle: 8
      move: 0
      inSpaceCombat: false
      inGroundCombat: true
    }
    {
      id: "pds"
      name: "PDS"
      cost: 2
      battle: 6
      move: 0
      notes: "Planetary Shield, Space Cannon"
      inSpaceCombat: false
      inGroundCombat: true
    }
    {
      id: "dock"
      name: "Space Dock"
      cost: 4
      battle: 0
      move: 0
      notes: "Produce Units, Fighter Capacity: 3"
      inSpaceCombat: false
      inGroundCombat: false
    }
  ]

  races: [
    {
      id: "sol"
      name: "Federation of Sol"
      shortName: "Sol"
      abilities: [
        "As an Action, you may spend one Command Counter from your Strategy Allocation to place 2 free Ground Forces on any 1 planet that you control."
        "During the Status Phase, you receive one extra Command Counter."
      ]
      units: [
        { id: 'ground', amount: 5 }
        { id: 'carrier', amount: 2 }
        { id: 'destroyer', amount: 1 }
        { id: 'dock', amount: 1 }
      ]
      technologies: ["antimass-deflectors", "cybernetics"]
      leaders: ["agent", "admiral", "diplomat"],
      modifiers: []
    }
    {
      id: "letnev"
      name: "The Barony of Letnev"
      shortName: "Letnev"
      abilities: [
        "Before any Combat Round, you may spend 2 Trade Goods to give all your ships +1, or all your Ground Forces +2, on their Combat Rolls for that Combat Round."
        "Your Fleets may always contain one more Ship than your number of Command Counters in your Fleet Supply."
      ]
      units: [
        { id: "dock", amount: 1 }
        { id: "dreadnought", amount: 1 }
        { id: "destroyer", amount: 1 }
        { id: "carrier", amount: 1 }
        { id: "ground", amount: 3 }
      ]
      technologies: ["hylar-v-assault-laser", "antimass-deflectors"]
      leaders: ["general", "admiral", "diplomat"]
      modifiers: [
        {
          id: "race-letnev-combat"
          scope: "combat"
          modify:
            battle: "+1"
          duration: 1
          automatic: false
        }
      ]
    }
    {
      id: "hacan"
      name: "The Emirates of Hacan"
      shortName: "Hacan"
      abilities: [
        "During the Status Phase, you may trade Action Cards with other players."
        "You do not need to spend a Command Counter to execute the secondary ability of the Trade Strategy."
        "When you receive Trade Goods from one of your Trade Agreements, you receive one additional Trade Good."
        "Your trades do not require approval during Trade Negotiations and no player may ever, except for war, break a Trade Contract with you."
      ]
      units: [
        { id: "ground", amount: 4 }
        { id: "carrier", amount: 2 }
        { id: "cruiser", amount: 1 }
        { id: "fighter", amount: 2 }
        { id: "dock", amount: 1 }
      ]
      technologies: ["enviro-compensator", "sarween-tools"]
      leaders: ["general", "scientist", "diplomat"]
      modifiers: []
    }
    {
      id: "norr"
      name: "Sardakk N'orr"
      shortName: "N'orr"
      abilities: [
        "You receive +1 on *all* your combat rolls."
      ]
      units: [
        { id: "ground", amount: 5 }
        { id: "carrier", amount: 1 }
        { id: "cruiser", amount: 1 }
        { id: "pds", amount: 1 }
        { id: "dock", amount: 1 }
      ]
      technologies: ["hylar-v-assault-laser", "deep-space-cannon"]
      leaders: ["admiral", "general", "general"]
      modifiers: [
        {
          id: "race-norr-combat"
          scope: "combat"
          modify:
            battle: "+1"
        }
      ]
    }
    {
      id: "jolnar"
      name: "Universities of Jol-Nar"
      shortName: "Jol-Nar"
      abilities: [
        "You receive -1 on *all* your combat rolls."
        "When executing the Secondary Ability of the Technology Strategy, you may execute both its Primary Ability and the Secondary ability."
        "You may spend a Command Counter from your Strategy Allocation, to immediately re-roll any of your die rolls."
      ]
      units: [
        { id: "ground", amount: 2 }
        { id: "carrier", amount: 2 }
        { id: "fighter", amount: 1 }
        { id: "pds", amount: 2 }
        { id: "dreadnought", amount: 1 }
        { id: "dock", amount: 1 }
      ]
      technologies: ["hylar-v-assault-laser", "antimass-deflectors", "enviro-compensator", "sarween-tools"]
      leaders: ["scientist", "scientist", "admiral"]
      modifiers: [
        {
          id: "race-jolnar-combat"
          scope: "combat"
          modify:
            battle: "-1"
        }
      ]
    }
    {
      id: "l1z1x"
      name: "The L1Z1X Mindnet"
      shortName: "L1Z1X"
      abilities: [
        "The base cost of your Dreadnought units starts at 4."
        "You start with one extra Command Counter in your Strategic Allocation area."
        "Your Dreadnought units receive +1 during Space Battles, and your Ground Force units receive +1 when attacking during Invasion Combat."
      ]
      units: [
        { id: "dock", amount: 1 }
        { id: "carrier", amount: 1 }
        { id: "ground", amount: 5 }
        { id: "dreadnought", amount: 1 }
        { id: "fighter", amount: 3 }
        { id: "pds", amount: 1 }
      ]
      technologies: ["enviro-compensator", "stasis-capsules", "cybernetics", "hylar-v-assault-laser"]
      leaders: ["agent", "scientist", "diplomat"]
      modifiers: [
        {
          id: "race-l1z1x-dreadnought"
          scope: "space"
          unitRequires:
            id: "dreadnought"
          modify:
            battle: "+1"
        }
        {
          id: "race-l1z1x-ground-force"
          scope: "ground"
          stance: "attacker"
          unitRequires:
            id: "ground"
          modify:
            battle: "+1"
        }
      ]
    }
    {
      id: "mentak"
      name: "The Mentak Coalition"
      shortName: "Mentak"
      abilities: [
        "You start the game with one additional Command Counter in your Fleet Supply area."
        "During the Strategy Phase, you may take one Trade Good token from up to two different players. Each target player must have at least 3 Trade Goods."
        "Before your Space Battles begin, you may fire with up to 2 Cruisers or Destroyers (any mix). Enemy casualties are taken immediately, with no return fire allowed."
      ]
      units: [
        { id: "carrier", amount: 1 }
        { id: "cruiser", amount: 3 }
        { id: "dock", amount: 1 }
        { id: "pds", amount: 1 }
        { id: "ground", amount: 4 }
      ]
      technologies: ["hylar-v-assault-laser", "enviro-compensator"]
      leaders: ["agent", "diplomat", "admiral"]
      modifiers: [
        {
          id: "race-mentak-pre-battle"
          scope: "space"
          round: 0
          duration: 1
          unitRequires:
            id: ["cruiser", "destroyer"]
          special: "TBD"
        }
      ]
    }
    {
      id: "naalu"
      name: "The Naalu Collective"
      shortName: "Naalu"
      abilities: [
        "The initiative number on your chosen Stratagy Card is always \"0\" (replacing the normal initiative number of the Stratagy Card). You are always first in the order of play."
        "If attacked, a Naalu fleet may retreat before the beginning of the Space Battle step of the Tactical Action sequence (following the normal retreat rules and restrictions)."
        "Naalu Fighters receive +1 on combat rolls during Space Battles."
      ]
      units: [
        { id: "dock", amount: 1 }
        { id: "ground", amount: 4 }
        { id: "pds", amount: 1 }
        { id: "carrier", amount: 1 }
        { id: "cruiser", amount: 1 }
        { id: "destroyer", amount: 1 }
        { id: "fighter", amount: 4 }
      ]
      technologies: ["antimass-deflectors", "enviro-compensator"]
      leaders: ["admiral", "agent", "diplomat"]
      modifiers: [
        {
          id: "race-naalu-fighters"
          scope: "space"
          unitRequires:
            id: "fighter"
          modify:
            battle: "+1"
        }
      ]
    }
    {
      id: "xxcha"
      name: "The Xxcha Kingdom"
      shortName: "Xxcha"
      abilities: [
        "When executing the Secondary Ability of the Diplomacy Strategy, you may execute the primary ability instead."
        "Immediately after a Political Card has been drawn and read aloud, you may spend one Command Counter from your Strategy Allocation to cancel the card, and force another Political Card to be drawn."
        "Your opponents receive -1 on all combat rolls against you during the first combat round of all Space Battles and Invasion Combat."
      ]
      units: [
        { id: "dock", amount: 1 }
        { id: "fighter", amount: 3 }
        { id: "pds", amount: 1 }
        { id: "carrier", amount: 1 }
        { id: "ground", amount: 2 }
        { id: "cruiser", amount: 2 }
      ]
      technologies: ["antimass-deflectors", "enviro-compensator"]
      leaders: ["admiral", "diplomat", "diplomat"]
      modifiers: [
        {
          id: "race-xxcha-first-round"
          scope: "combat"
          round: 1
          duration: 1
          modifyOpponent:
            battle: "-1"
        }
      ]
    }
    # {
    #   id: ""
    #   name: ""
    #   shortName: ""
    #   abilities: []
    #   units: [
    #     { id: "", amount: 1 }
    #   ]
    #   technologies: []
    #   leaders: ["", "", ""]
    #   modifiers: []
    # }
  ]

  technologies: [

  ]

  modifiers: [
    {
      id: "global-antifighter-barrage"
      scope: "space"
      round: 0
      duration: 1
      unitRequires:
        antifighter: true
      modify:
        dice: 2
    }
    {
      id: "global-high-alert"
      scope: "space"
      round: 1
      modify:
        battle: "+1"
      automatic: false
    }
  ]

  colours: [
    'red'
    'orange'
    'yellow'
    'green'
    'blue'
    'purple'
    'gray'
    'black'
  ]
