class Player extends Backbone.Model
  defaults:
    raceId: null
    color: null
    number: 0

  initialize: ->
    @technologies = []
    if (rId = @get("raceId"))?
      @setRace(rId)

  getName: ->
    @get("name") or "Unnamed Player"

  getColor: ->
    @get("color")

  setColor: (value) ->
    @set("color", value)

  getNumber: ->
    @get("number")

  getRaceId: ->
    @get("raceId")

  getRace: ->
    @get("race")

  setRace: (race) ->
    if _.isString(race)
      race = Races.get(race)
    if race?
      @race = race
      # Add racial technologies
      @technologies = [].concat @race.technologies
      @set("raceId", race.id)
      @set("race", race)

  getTechnologyIds: ->
    _.map @technologies, (t) -> t.id

  getTechnologyModifiers: ->
    tech = _.filter(@technologies, (t) -> t.hasModifiers())
    _.flatten _.map(tech, (t) -> t.modifiers)


  addTechnology: (technology) ->
    unless _.include(@getTechnologyIds(), technology.id)
      @technologies.push technology

  removeTechnology: (technology) ->
    @technologies = _.reject @technologies, (t) ->
      t.id is technology.id

  toDbAttributes: ->
    {
      number: @getNumber()
      name: @getName()
      color: @getColor()
      race: @getRaceId()
      technologies: @getTechnologyIds().join(',')
    }

  toJSON: ->
    obj = super
    if @race?
      obj.race = @race.toJSON()
    obj
