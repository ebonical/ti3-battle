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
window.Units = new UnitCollection(Data.units)
window.Races = new RaceCollection(Data.races)
window.Technologies = new TechnologyCollection(Data.technologies)
window.Players = new PlayerCollection [
  {id: 1, name: 'Ebony', race: Races.get('xxcha'), color: 'red'}
  {id: 2, name: 'Aaron', race: Races.get('mentak'), color: 'blue'}
  {id: 3, name: 'Mike', race: Races.get('jolnar'), color: 'green'}
  {id: 4, name: 'Chris', race: Races.get('letnev'), color: 'yellow'}
  {id: 5, name: 'Eric', race: Races.get('l1z1x'), color: 'orange'}
]
window.GlobalModifiers = new ModifierCollection(Data.modifiers)

window.state =
  player: Players.first()
  battle: null

# init app
window.App = new AppView
