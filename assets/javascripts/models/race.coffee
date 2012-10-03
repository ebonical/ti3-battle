class Race extends Backbone.Model

  initialize: ->
    @technologies = _.map @get("technologies"), (tId) ->
      Technologies.get(tId)

  getName: ->
    @get("name")

  getModifiers: ->
    unless @modifiers?
      mods = @get("modifiers") or []
      @modifiers = (new Modifier(mod) for mod in mods)
    @modifiers

