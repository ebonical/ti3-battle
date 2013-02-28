class ti3.Unit extends Backbone.Model
  defaults:
    dice: 1

  getExpansion: ->
    @get("expansion")
