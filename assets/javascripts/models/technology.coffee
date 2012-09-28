class Technology extends Backbone.Model
  initialize: ->
    @modifiers = []
    for data in (@get("modifiers") || [])
      @modifiers.push new Modifier(data)

  hasModifiers: ->
    @modifiers.length > 0
