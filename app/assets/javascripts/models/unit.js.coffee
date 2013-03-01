class ti3.Unit extends Backbone.Model
  defaults:
    dice: 1
    expansion: "base"
    optionalRule: "none"

  getExpansion: ->
    @get("expansion")

  getOptionalRule: ->
    @get("optionalRule")

  isOptional: ->
    @getOptionalRule() != "none"
