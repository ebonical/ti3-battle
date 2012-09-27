class Race extends Backbone.Model

  getName: ->
    @get("name")

  getModifiers: ->
    unless @modifiers?
      mods = @get("modifiers") or []
      @modifiers = (new Modifier(mod) for mod in mods)
    @modifiers
