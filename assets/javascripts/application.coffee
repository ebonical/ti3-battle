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
window.GlobalModifiers = new ModifierCollection(Data.modifiers)

# Values available for current state of play
window.state =
  game: null
  player: null
  battle: null

# init app
window.App = new AppView

window.addEventListener 'load', ->
    new FastClick(document.body)
, false
