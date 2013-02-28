class ti3.PlayerCollection extends Backbone.Collection
  model: ti3.Player

class ti3.UnitCollection extends Backbone.Collection
  model: ti3.Unit

class ti3.RaceCollection extends Backbone.Collection
  model: ti3.Race

class ti3.TechnologyCollection extends Backbone.Collection
  model: ti3.Technology

class ti3.ModifierCollection extends Backbone.Collection
  model: ti3.Modifier

# init collections
ti3.Technologies = new ti3.TechnologyCollection(ti3.Data.technologies)
ti3.Units = new ti3.UnitCollection(ti3.Data.units)
ti3.Races = new ti3.RaceCollection(ti3.Data.races)
ti3.GlobalModifiers = new ti3.ModifierCollection(ti3.Data.modifiers)

# Values available for current state of play
window.state =
  game: null
  player: null
  battle: null

# init app
$ ->
  if $('#index.section').length > 0
    window.App = new ti3.AppView
