class Player extends Backbone.Model
  defaults:
    color: 'default'

  initialize: ->
    @race = @get("race")


  getName: ->
    @get("name") or "Unnamed Player"

  getColor: ->
    @get("color")


  toJSON: ->
    obj = super
    obj.race = @get('race').toJSON()
    obj
