
# Collections
class PlayerCollection extends Backbone.Collection
  model: Player

class UnitCollection extends Backbone.Collection
  model: Unit

class RaceCollection extends Backbone.Collection
  model: Race

class ModifierCollection extends Backbone.Collection
  model: Modifier


# init collections
window.Units = new UnitCollection(Data.units)
window.Races = new RaceCollection(Data.races)
window.Players = new PlayerCollection [
  {id: 1, name: 'Ebony', race: Races.get('sol'), color: 'red'}
  {id: 2, name: 'Aaron', race: Races.get('norr'), color: 'blue'}
]
window.GlobalModifiers = new ModifierCollection(Data.modifiers)

window.state =
  player: Players.first()
  battle: null

# init app
window.App = new AppView
