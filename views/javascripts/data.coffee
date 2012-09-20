expansions = [
  {
    id: "se"
    name: "Shattered Empire"
  }
]

units = [
  {
    id: "warsun"
    name: "War Sun"
    cost: 12
    battle: 3
    move: 2
    dice: 3
    bombard: true
    capacity: 6
    hitpoints: 2
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
    hitpoints: 2
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
    preCombat: true
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

races = [
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
    leaders: ["agent", "admiral", "diplomat"]
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
        scope: "space-combat"
        modifier: 1
        duration: 1
        automatic: false
      }
      {
        scope: "ground-combat"
        modifier: 2
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
  }
  {
    id: "norr"
    name: "Sardakk N'orr"
    shortName: "N'orr"
    abilities: [
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
        scope: "space-combat"
        modifier: 1
        duration: 0
        automatic: true
      }
      {
        scope: "ground-combat"
        modifier: 1
        duration: 0
        automatic: true
      }
    ]
  }
  {
    id: "jolnar"
    name: "Universities of Jol-Nar"
    shortName: "Jol-Nar"
    abilities: [
      "You receive -1 on your combat rolls during all Space Battles and Invasion Combat."
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
        scope: "space-combat"
        modifier: -1
        automatic: true
        duration: 0
      }
      {
        scope: "ground-combat"
        modifier: -1
        automatic: true
        duration: 0
      }
    ]
  }
]

technologies = [

]

colours = [
  'red'
  'orange'
  'yellow'
  'green'
  'blue'
  'purple'
  'gray'
]

window.databank = {
  expansions
  units
  races
  colours
  technologies
}