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
    {
      id: "yssaril"
      name: "The Yssaril Tribes"
      shortName: "Yssaril"
      abilities: [
        "You are allowed to skip your action turn during the Action Phase. You may not skip two such action turns in a row."
        "You draw 1 additional Action Card during every Status Phase. You are never limited to a hand-size of Action Cards, regardless of the game rules and any active Political Cards."
        "Once during every Stratagy Phase, you may look at one other player's hand of Action Cards."
      ]
      units: [
        { id: "dock", amount: 1 }
        { id: "ground", amount: 5 }
        { id: "pds", amount: 1 }
        { id: "carrier", amount: 2 }
        { id: "cruiser", amount: 1 }
        { id: "fighter", amount: 2 }
      ]
      technologies: ["antimass-deflectors", "xrd-transporter"]
      leaders: ["agent", "agent", "admiral"]
      modifiers: []
    }
    {
      id: "winnu"
      expansion: "se"
      name: "The Winnu"
      shortName: "Winnu"
      abilities: [
        "You may always add the Influence value of your Home System planet to your votes, even if it is exhausted."
        "Your planets that contain at least 1 Ground Force are immune to the Local Unrest Action Card."
        "You do not need to spend a Command Counter to execute the secondary ability of the Technology Strategy."
      ]
      units: [
        { id: "ground", amount: 3 }
        { id: "carrier", amount: 1 }
        { id: "cruiser", amount: 1 }
        { id: "fighter", amount: 2 }
        { id: "pds", amount: 1 }
        { id: "dock", amount: 1 }
      ]
      technologies: ["antimass-deflectors", "enviro-compensator", "stasis-capsules"]
      leaders: ["agent", "scientist", "admiral"]
      modifiers: []
    }
    {
      id: "muaat"
      expansion: "se"
      name: "Embers of Muaat"
      shortName: "Muaat"
      abilities: [
        "Your War Suns have a base movement of 1 until you acquire the prerequisites at which point it becomes 2."
        "As an Action, you may spend one Strategy Command Counter to place 2 free Fighters *or* 1 free Destroyer in any one System containing one of your War Suns."
        "Your ships may move through, but not end their movement in Supernova systems."
      ]
      units: [
        { id: "ground", amount: 4 }
        { id: "fighter", amount: 2 }
        { id: "warsun", amount: 1 }
        { id: "dock", amount: 1 }
      ]
      technologies: ["enviro-compensator", "war-sun"]
      leaders: ["general", "scientist", "diplomat"]
      modifiers: []
    }
    {
      id: "yin"
      expansion: "se"
      name: "The Yin Brotherhood"
      shortName: "Yin"
      abilities: [
        "Before the beginning of an Invasion Combat in which you are the attacker, you may roll 1 die. On a 5+ your opponent loses 1 Ground Force and you gain 1 Ground Force."
        "Immediately before the second round of a Space Battle, you may discard 1 of your participating Destroyers or Cruisers to immediately inflict 1 hit on an opposing ship."
        "Once per game round, as an action, you may choose an unexhausted Planet you control and reverse its Resource and Influence values for the rest of the round."
      ]
      units: [
        { id: "ground", amount: 4 }
        { id: "carrier", amount: 2 }
        { id: "destroyer", amount: 1 }
        { id: "fighter", amount: 4 }
        { id: "dock", amount: 1 }
      ]
      technologies: ["hylar-v-assault-laser", "automated-defense-turrets"]
      leaders: ["general", "diplomat", "agent"]
      modifiers: [
        {
          id: "race-yin-invasion-special"
          scope: "ground"
          stance: "attacker"
          round: 0
          duration: 1
          special: "TBD"
        }
      ]
    }
    {
      id: "saar"
      expansion: "se"
      name: "The Clan of Saar"
      shortName: "Saar"
      abilities: [
        "Gain 1 Trade Good every time you acquire a new planet."
        "Your Space Docks have a movement of 1, but may not build during the same activation in which they move."
        "Your Space Docks are never placed on planets and have a production capacity of 4. Your Space Docks are destroyed if they are ever left alone with an enemy ship."
        "You may fulfill Objectives even if you don't control your Home System."
      ]
      units: [
        { id: "ground", amount: 4 }
        { id: "carrier", amount: 2 }
        { id: "fighter", amount: 2 }
        { id: "cruiser", amount: 1 }
        { id: "dock", amount: 1 }
      ]
      technologies: ["antimass-deflectors", "xrd-transporter"]
      leaders: ["agent", "admiral", "general"]
      modifiers: []
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
