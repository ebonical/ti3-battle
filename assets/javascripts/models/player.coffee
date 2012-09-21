class Player extends Backbone.Model
  defaults:
    color: 'default'

  toJSON: ->
    obj = super
    obj.race = @get('race').toJSON()
    obj
