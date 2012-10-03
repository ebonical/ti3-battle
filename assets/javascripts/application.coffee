class PlayerCollection extends Backbone.Collection
  model: Player

class UnitCollection extends Backbone.Collection
  model: Unit

class RaceCollection extends Backbone.Collection
  model: Race

class TechnologyCollection extends Backbone.Collection
  model: Technology

class ModifierCollection extends Backbone.Collection
  model: Modifier

# init collections
window.Technologies = new TechnologyCollection(Data.technologies)
window.Units = new UnitCollection(Data.units)
window.Races = new RaceCollection(Data.races)
window.Players = new PlayerCollection
for num in [1..8]
  Players.add
    number: num
    name: "Player #{num}"
window.GlobalModifiers = new ModifierCollection(Data.modifiers)

# Values available for current state of play
window.state =
  gameId: null
  gameToken: null
  player: null
  battle: null

# init app
window.App = new AppView
