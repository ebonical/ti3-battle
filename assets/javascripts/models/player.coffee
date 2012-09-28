class Player extends Backbone.Model
  defaults:
    color: 'default'

  initialize: ->
    @race = @get("race")
    @technologies = []


  getName: ->
    @get("name") or "Unnamed Player"

  getColor: ->
    @get("color")

  getTechnologyIds: ->
    _.map @technologies, (t) -> t.id

  getTechnologyModifiers: ->
    tech = _.filter(@technologies, (t) -> t.hasModifiers())
    _.flatten _.map(tech, (t) -> t.modifiers)


  addTechnology: (technology) ->
    unless _.include(@technologies, technology.id)
      @technologies.push technology

  removeTechnology: (technology) ->
    @technologies = _.reject @technologies, (t) ->
      t.id is technology.id

  toJSON: ->
    obj = super
    obj.race = @get('race').toJSON()
    obj
