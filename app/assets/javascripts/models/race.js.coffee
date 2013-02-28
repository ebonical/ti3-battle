class ti3.Race extends Backbone.Model

  initialize: ->
    @technologies = _.map @get("technologies").split(','), (tId) ->
      ti3.Technologies.get(tId)

  getName: ->
    @get("name")

  getShortName: ->
    @get("shortName")

  getModifiers: ->
    unless @modifiers?
      mods = @get("modifiers") or []
      @modifiers = (new ti3.Modifier(mod) for mod in mods)
    @modifiers

