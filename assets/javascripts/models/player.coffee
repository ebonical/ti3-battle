class Player extends Backbone.Model
  defaults:
    raceId: null
    color: null
    number: 0

  initialize: ->
    @technologies = []
    rId = @get("raceId") or @get("race")
    @setRace(rId) if rId?
    # Add technologies from attributes
    if @get("technologies")?
      techIds = @get("technologies").split(",")
      @technologies = _.map techIds, (tId) -> Technologies.get(tId)

  url: ->
    "/players/#{@id}"

  getName: ->
    @get("name") or "Unnamed Player"

  getColor: ->
    @get("color")

  setColor: (value) ->
    @set("color", value)

  getNumber: ->
    @get("number")

  getGameToken: ->
    @get("gameToken")

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


  hasTechnology: (technology) ->
    _.include(@getTechnologyIds(), technology.id)

  addTechnology: (technology) ->
    if not @hasTechnology(technology)
      @technologies.push technology
      @set "technologies", @getTechnologyIds().join(',')
      @_save()

  removeTechnology: (technology) ->
    if @hasTechnology(technology)
      @technologies = _.reject @technologies, (t) -> t.id is technology.id
      @set "technologies", @getTechnologyIds().join(',')
      @_save()

  _save: ->
    @save
      player: @toDbAttributes()

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
