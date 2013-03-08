ti3.Data =
  expansions: [
    {
      id: "se"
      name: "Shattered Empire"
    }
  ]

  optionalRules: [
    {
      id: "shock_troops"
      name: "Shock Troops"
      expansion: "se"
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
      maxQuantity: 2
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
      maxQuantity: 5
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
      maxQuantity: 8
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
      maxQuantity: 8
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
      inGroundCombat: true
    }
    {
      id: "carrier"
      name: "Carrier"
      cost: 3
      battle: 9
      move: 1
      capacity: 6
      maxQuantity: 4
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
      activeGroundCombatUnit: true
      planetaryControl: true
    }
    {
      id: "shock"
      name: "Shock Troop"
      cost: 1
      battle: 5
      move: 0
      inSpaceCombat: false
      inGroundCombat: true
      activeGroundCombatUnit: true
      planetaryControl: true
      optionalRule: "shock_troops"
    }
    {
      id: "pds"
      name: "PDS"
      cost: 2
      battle: 6
      move: 0
      maxQuantity: 6
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
      maxQuantity: 3
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
      technologies: "antimass-deflectors,cybernetics"
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
      technologies: "hylar-v-assault-laser,antimass-deflectors"
      leaders: ["general", "admiral", "diplomat"]
      modifiers: [
        {
          id: "race-letnev-space"
          summary: "Ships get +1"
          scope: "space"
          modify:
            battle: "+1"
          duration: 1
          automatic: false
        }
        {
          id: "race-letnev-ground"
          summary: "Ground Forces get +2"
          scope: "ground"
          unitRequires:
            id: ["ground", "shock"]
          modify:
            battle: "+2"
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
      technologies: "enviro-compensator,sarween-tools"
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
      technologies: "hylar-v-assault-laser,deep-space-cannon"
      leaders: ["admiral", "general", "general"]
      modifiers: [
        {
          id: "race-norr-combat"
          summary: "Everything at +1"
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
        "You may spend a Command Counter from your Strategy Allocation, to immediately re-roll any one of your die rolls."
      ]
      units: [
        { id: "ground", amount: 2 }
        { id: "carrier", amount: 2 }
        { id: "fighter", amount: 1 }
        { id: "pds", amount: 2 }
        { id: "dreadnought", amount: 1 }
        { id: "dock", amount: 1 }
      ]
      technologies: "hylar-v-assault-laser,antimass-deflectors,enviro-compensator,sarween-tools"
      leaders: ["scientist", "scientist", "admiral"]
      modifiers: [
        {
          id: "race-jolnar-combat"
          summary: "Everything at -1"
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
      technologies: "enviro-compensator,stasis-capsules,cybernetics,hylar-v-assault-laser"
      leaders: ["agent", "scientist", "diplomat"]
      modifiers: [
        {
          id: "race-l1z1x-dreadnought"
          summary: "Dreadnoughts +1 in Space Battles"
          scope: "space"
          unitRequires:
            id: "dreadnought"
          modify:
            battle: "+1"
        }
        {
          id: "race-l1z1x-ground-force"
          summary: "Ground Forces get +1"
          scope: "ground"
          stance: "attacker"
          unitRequires:
            id: ["ground", "shock"]
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
      technologies: "hylar-v-assault-laser,enviro-compensator"
      leaders: ["agent", "diplomat", "admiral"]
      modifiers: [
        {
          id: "race-mentak-pre-battle"
          summary: "Cruisers, Destroyers first strike"
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
      technologies: "antimass-deflectors,enviro-compensator"
      leaders: ["admiral", "agent", "diplomat"]
      modifiers: [
        {
          id: "race-naalu-fighters"
          summary: "Fighers +1 in Space Battles"
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
      technologies: "antimass-deflectors,enviro-compensator"
      leaders: ["admiral", "diplomat", "diplomat"]
      modifiers: [
        {
          id: "race-xxcha-first-round"
          summary: "Xxcha opponent -1 in 1st round"
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
      technologies: "antimass-deflectors,xrd-transporters"
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
      technologies: "antimass-deflectors,enviro-compensator,stasis-capsules"
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
      technologies: "enviro-compensator,war-sun,sarween-tools"
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
      technologies: "hylar-v-assault-laser,automated-defense-turrets"
      leaders: ["general", "diplomat", "agent"]
      modifiers: [
        {
          id: "race-yin-invasion-special"
          summary: "Special attack on Ground Forces"
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
      technologies: "antimass-deflectors,xrd-transporters"
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
    {
      id: "hylar-v-assault-laser"
      name: "Hylar V Assault Laser"
      description: "Cruisers and Destroyers receive +1 in all combat rolls."
      color: "red"
      modifiers: [
        {
          id: "tech-hylar"
          summary: "Cruisers, Destroyers always +1"
          scope: "combat"
          unitRequires:
            id: ["cruiser", "destroyer"]
          modify:
            battle: "+1"
        }
      ]
    }
    {
      id: "automated-defense-turrets"
      name: "Automated Defense Turrets"
      description: "During all Anti-Fighter Barrage rolls Destroyers receive +2 and an additional die."
      color: "red"
      expansion: "se"
      prerequisites: ["hylar-v-assault-laser"]
      andor: "and"
      modifiers: [
        {
          id: "tech-defense-turrets"
          summary: "Destroyers, extra die and +2"
          scope: "space"
          round: 0
          duration: 1
          unitRequires:
            id: "destroyer"
          modify:
            battle: "+2"
            dice: "+1"
        }
      ]
      plumbing:
        stub: [155,10]
        anchorsOut:
          "assault-cannon": "Left"
    }
    {
      id: "deep-space-cannon"
      name: "Deep Space Cannon"
      description: "Enemy fleets in adjacent systems are now in range of your PDS."
      color: "red"
      prerequisites: ["hylar-v-assault-laser"]
      andor: "and"
      modifiers: []
      plumbing:
        stub: [5,30]
        anchorsOut:
          "war-sun": "Right"
    }
    {
      id: "enviro-compensator"
      name: "Enviro Compensator"
      description: "Production capacity of your Space Docks is increased by 1."
      color: "yellow"
      prerequisites: []
      andor: "and"
      modifiers: []
    }
    {
      id: "antimass-deflectors"
      name: "Antimass Deflectors"
      description: "Your ships may pass through, but not stop in, Asteroid Fields."
      color: "blue"
      prerequisites: []
      andor: "and"
      modifiers: []
    }
    {
      id: "sarween-tools"
      name: "Sarween Tools"
      description: "Whenever you produce units at any Space Dock, you now receive +1 resource with which to build units."
      color: "yellow"
      prerequisites: ["enviro-compensator"]
      andor: "and"
      modifiers: []
      plumbing:
        stub: [5,16]
    }
    {
      id: "stasis-capsules"
      name: "Stasis Capsules"
      description: "Cruisers and Dreadnoughts can now carry one Ground Force unit."
      color: "green"
      prerequisites: ["enviro-compensator"]
      andor: "and"
      modifiers: []
      plumbing:
        stubs:
          "neural-motivator": [81,10]
          "cybernetics": [35,10]
          "micro-technology": [10,35]
        anchorsOut:
          "neural-motivator": "Right"
          "cybernetics": "Right"
          "micro-technology": "Left"
    }
    {
      id: "micro-technology"
      name: "Micro Technology"
      description: "When you receive Trade Goods from your Trade Agreements, you now receive +1 Trade Good for each of your active Trade Agreements."
      color: "yellow"
      prerequisites: ["sarween-tools", "stasis-capsules"]
      andor: "or"
      modifiers: []
      plumbing:
        stub: [5,20]
        anchorsIn:
          "stasis-capsules": "Right"
    }
    {
      id: "cybernetics"
      name: "Cybernetics"
      description: "Fighters receive +1 on all combat rolls."
      color: "green"
      prerequisites: ["stasis-capsules","antimass-deflectors"]
      andor: "or"
      modifiers: [
        {
          id: "tech-cybernetics"
          summary: "Fighters always +1"
          scope: "combat"
          unitRequires:
            id: "fighter"
          modify:
            battle: "+1"
        }
      ]
      plumbing:
        stub: [84,5]
        anchorsIn:
          "stasis-capsules": "Left"
    }
    {
      id: "xrd-transporters"
      name: "Xrd Transporters"
      description: "Carriers now receive +1 movement."
      color: "blue"
      prerequisites: ["antimass-deflectors"]
      andor: "and"
      modifiers: []
      plumbing:
        stubs:
          "type-iv-drive": [118,100]
          "maneuvering-jets": [49,0]
          "light-wave-deflector": [213,10]
    }
    {
      id: "graviton-laser-system"
      name: "Graviton Laser System"
      description: "PDS get one re-roll for each missed combat roll."
      color: "yellow"
      prerequisites: ["deep-space-cannon"]
      andor: "and"
      modifiers: [
        {
          id: "tech-graviton-laser"
          summary: "PDS get a re-roll on misses"
          scope: "combat"
          unitRequires:
            id: "pds"
          modify:
            rerolls: 1
        }
      ]
      plumbing:
        anchorsIn:
          "deep-space-cannon": "Right"
    }
    {
      id: "magen-defense-grid"
      name: "Magen Defense Grid"
      description: "Your PDS units receive +1 on all combat rolls. Defending Ground Forces with a PDS get +1 on all combat rolls during Invasion Combat."
      color: "red"
      prerequisites: ["deep-space-cannon"]
      andor: "and"
      modifiers: [
        {
          id: "tech-magen-ground-forces"
          summary: "Ground Forces +1 with PDS"
          scope: "ground"
          stance: "defender"
          unitRequires:
            id: ["ground", "shock"]
          modify:
            battle: "+1"
          supportRequires:
            id: "pds"
        }
        {
          id: "tech-magen-pds"
          summary: "PDS get +1"
          scope: "combat"
          unitRequires:
            id: "pds"
          modify:
            battle: "+1"
        }
      ]
    }
    {
      id: "integrated-economy"
      name: "Integrated Economy"
      description: "When producing units at your Space Docks you may place them in any activated adjacent system that is empty or friendly. You may place PDS and Ground Force units on any friendly planet within this range."
      color: "yellow"
      prerequisites: ["micro-technology","cybernetics"]
      andor: "and"
      modifiers: []
      plumbing:
        anchorsIn:
          "cybernetics": "Right"
    }
    {
      id: "neural-motivator"
      name: "Neural Motivator"
      description: "Draw one extra Action Card during each Status Phase."
      color: "green"
      prerequisites: ["stasis-capsules","micro-technology"]
      andor: "or"
      modifiers: []
      plumbing:
        stub: [40,10]
        anchorsIn:
          "micro-technology": "Left"
          "stasis-capsules": "Right"
    }
    {
      id: "gen-synthesis"
      name: "Gen Synthesis"
      description: "All of your Ground Forces receive +1 during Invasion Combat. When destroyed, roll one die. On a result of 5+ return the unit to your Home System."
      color: "green"
      prerequisites: ["cybernetics"]
      andor: "and"
      modifiers: [
        {
          id: "tech-gen-synthesis"
          summary: "Ground Forces +1"
          scope: "ground"
          unitRequires:
            id: ["ground", "shock"]
          modify:
            battle: "+1"
        }
      ]
      plumbing:
        stub: [30,10]
    }
    {
      id: "maneuvering-jets"
      name: "Maneuvering Jets"
      description: "Opponent receives -1 on all PDS rolls targeting your ships (or -2 if firing from an adjacent system). Additionally you receive -1 to all your Space Mine rolls and ships don't have to stop for Ion Storms."
      color: "blue"
      expansion: "se"
      prerequisites: ["xrd-transporters"]
      andor: "and"
      modifiers: []
    }
    {
      id: "war-sun"
      name: "War Sun"
      description: "You are now allowed to produce War Sun units."
      color: "red"
      prerequisites: ["deep-space-cannon","sarween-tools"]
      andor: "and"
      modifiers: []
      plumbing:
        anchorsIn:
          "sarween-tools": "Left"
          "deep-space-cannon": "Right"
    }
    {
      id: "assault-cannon"
      name: "Assault Cannon"
      description: "Dreadnoughts get one free shot before any Space Battle begins. Casualties are removed immediately with no return fire."
      color: "red"
      prerequisites: ["cybernetics","automated-defense-turrets"]
      andor: "and"
      modifiers: [
        {
          id: "tech-assault-cannon"
          scope: "space"
          round: 0
          duration: 1
          unitRequires:
            id: "dreadnought"
          special: "TBD"
        }
      ]
      plumbing:
        stub: [221,10]
        anchorsIn:
          "cybernetics": "Left"
    }
    {
      id: "nano-technology"
      name: "Nano Technology"
      description: "Your Dreadnoughts and War Suns may not be targeted by Action Cards. When you claim a planet, you gain its planet card refreshed."
      color: "yellow"
      expansion: "se"
      prerequisites: ["micro-technology"]
      andor: "and"
      modifiers: []
    }
    {
      id: "dacxive-animators"
      name: "Dacxive Animators"
      description: "If you win an Invasion Combat, roll one die for every Ground Force unit killed (yours and your opponent's). Every roll of 6+ gains you one free Ground Force to be placed on that planet."
      color: "green"
      prerequisites: ["neural-motivator"]
      andor: "and"
      modifiers: []
      plumbing:
        stub: [10,20]
    }
    {
      id: "type-iv-drive"
      name: "Type IV Drive"
      description: "Youre Cruisers and Dreadnoughts now receive +1 movement."
      color: "blue"
      prerequisites: ["neural-motivator","xrd-transporters"]
      andor: "and"
      modifiers: []
      plumbing:
        stub: [15,61]
        anchorsIn:
          "neural-motivator": "Left"

    }
    {
      id: "hyper-metabolism"
      name: "Hyper Metabolism"
      description: "During each Status Phase you gain 1 additional Command Counter. Also, before drawing Action Cards you may discard 1 from your hand to draw 1 additional card."
      color: "green"
      expansion: "se"
      prerequisites: ["gen-synthesis"]
      andor: "and"
      modifiers: []
    }
    {
      id: "light-wave-deflector"
      name: "Light/Wave Deflector"
      description: "Your ships may move through systems containing enemy ships and continue their movement to the activated system."
      color: "blue"
      prerequisites: ["magen-defense-grid","xrd-transporters"]
      andor: "and"
      modifiers: []
      plumbing:
        stub: [195,10]
        anchorsIn:
          "xrd-transporters": "Left"
    }
    {
      id: "graviton-negator"
      name: "Graviton Negator"
      description: "Dreadnoughts may bombard planets containing PDS units. Your Fighters may participate in Invasion Combat. Surviving Fighters return to space after combat and may never establish control of a planet."
      color: "red"
      prerequisites: ["assault-cannon","dacxive-animators"]
      andor: "or"
      modifiers: [
        {
          id: "tech-graviton-negator-dreadnought"
          scope: "ground"
          round: 0
          duration: 1
          unitRequires:
            id: "dreadnought"
          modify:
            ignorePds: true
        }
        {
          id: "tech-graviton-negator-fighter"
          scope: "ground"
          stance: "attacker"
          round: 0
          unitRequires:
            id: "fighter"
          modify:
            activeGroundCombatUnit: true
        }
      ]
      plumbing:
        anchorsIn:
          "assault-cannon": "Right"
    }
    {
      id: "advanced-fighters"
      name: "Advanced Fighters"
      description: "Your Fighters receive +1 to all combat rolls. Also, they no longer need the support of a Carrier or Space Dock and may move independently with a movement rate of 2. Fighters in excess of a sytem's normal capacity will count towards your Fleet Supply limit."
      color: "blue"
      prerequisites: ["type-iv-drive"]
      andor: "and"
      modifiers: [
        {
          id: "tech-advanced-fighters"
          scope: "combat"
          unitRequires:
            id: "fighter"
          modify:
            battle: "+1"
        }
      ]
    }
    {
      id: "transit-diodes"
      name: "Transit Diodes"
      description: "As an action you may spend 1 Strategic Command Counter to immediately move up to 4 of your Ground Forces from one planet to any other planet you control."
      color: "yellow"
      prerequisites: ["light-wave-deflector","dacxive-animators"]
      andor: "and"
      modifiers: []
      plumbing:
        stub: [71,15]
        anchorsIn:
          "dacxive-animators": "Left"
    }
    {
      id: "fleet-logistics"
      name: "Fleet Logistics"
      description: "When taking a Tactical Action, you may now take 2 Tactical Actions, one after the other, before your turn ends."
      color: "blue"
      prerequisites: ["graviton-negator"]
      andor: "and"
      modifiers: []
    }
    {
      id: "x-89-bacterial-weapon"
      name: "X-89 Bacterial Weapon"
      description: "Instead of normal bombardment your Dreadnought or War Sun units may now immediately destroy all enemy Ground Forces on the planet. Then discard all of your Action Cards."
      color: "red"
      prerequisites: ["transit-diodes", "assault-cannon"]
      andor: "or"
      modifiers: []
      plumbing:
        anchorsIn:
          "transit-diodes": "Left"
    }
  ]

  leaders: [
    {
      id: "general"
      name: "General"
      modifiers: [
        {
          id: "leader-general-attacker"
          summary: "2 rerolls"
          scope: "ground"
          stance: "attacker"
          modify:
            rerolls: 2
          automatic: false
        }
        {
          id: "leader-general-defender"
          summary: "Ground Forces get +1"
          scope: "ground"
          stance: "defender"
          unitRequires:
            id: ["ground", "shock"]
          modify:
            battle: "+1"
          automatic: false
        }
        {
          id: "leader-general-bombardment"
          summary: "Bombardments at -4"
          scope: "ground"
          stance: "defender"
          round: 0
          duration: 1
          modifyOpponent:
            battle: "-4"
          automatic: false
        }
      ]
    }
    {
      id: "admiral"
      name: "Admiral"
      modifiers: [
        {
          id: "leader-admiral"
          summary: "Ship gets 1 extra die"
          scope: "space"
          modify:
            dice: "+1"
          automatic: false
        }
      ]
    }
    {
      id: "scientist"
      name: "Scientist"
      modifiers: [
        {
          id: "leader-scientist-pds"
          summary: "PDS gets +1"
          scope: "ground"
          stance: "defender"
          unitRequires:
            id: "pds"
          modify:
            battle: "+1"
          automatic: false
        }
        {
          id: "leader-scientist-bombardment"
          summary: "War Suns cannot ignore PDS"
          scope: "ground"
          stance: "defender"
          modifyOpponent:
            ignorePds: false
          automatic: false
        }
      ]
    }
    {
      id: "diplomat"
      name: "Diplomat"
    }
    {
      id: "agent"
      name: "Agent"
      modifiers: [
        {
          id: "leader-agent"
          summary: "PDS cannot fire"
          scope: "ground"
          stance: "attacker"
          unitRequires:
            id: "pds"
          modifyOpponent:
            dice: 0
        }
      ]
    }
  ]

  modifiers: [
    {
      id: "global-antifighter-barrage"
      summary: "Anti-Fighter barrage"
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
      summary: "High Alert!"
      scope: "space"
      round: 1
      modify:
        battle: "+1"
      automatic: false
    }
  ]

  colors: [
    'red'
    'orange'
    'yellow'
    'green'
    'blue'
    'purple'
    'gray'
    'black'
  ]
