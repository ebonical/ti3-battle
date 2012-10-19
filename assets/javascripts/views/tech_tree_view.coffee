class TechTreeView extends Backbone.View
  el: ".section#techtree"

  initialize: ->
    @elTree = @$el.find('.technologies')
    @levels = {}
    @render()
    # register listeners for all players
    if state.game?
      for player in state.game.players
        player.on "change:technologies", (model, technologies) =>
          @_refreshTechnologies(model)

  refresh: ->
    # mark current player's researched technologies
    if @_hasPlayerChanged()
      @currentPlayerNumber = state.player.getNumber()
      @$el.find('h1 span').text state.player.race.getShortName()
      @_refreshTechnologies(state.player)

  _hasPlayerChanged: ->
    state.player? and state.player.getNumber() != @currentPlayerNumber

  _refreshTechnologies: (player) ->
    if player.getNumber() is @currentPlayerNumber
      @$el.find('.tech').removeClass 'researched'
      ids = _.map(player.getTechnologyIds(), (id) -> "##{id}").join(', ')
      $(ids).addClass 'researched'

  # Only show the pipes leading to a specific technology
  showPath: (toTech) ->
    if @_pathToTechHighlighted is toTech
      @_pathToTechHighlighted = null
      tech.showConnections() for tech in @technologies
    else
      @_pathToTechHighlighted = toTech
      # visible technologies are those from current back through prerequisites
      visible = _.map toTech.getAncestorsAndSelf(), (t) -> t.id
      for tech in @technologies
        if _.include(visible, tech.id)
          tech.showConnections()
        else
          tech.hideConnections()

  initPlumbing: ->
    tech.initPlumbing() for tech in Technologies.models
    # repaint to make sure all connections are sound
    jsPlumb.repaintEverything()

  render: ->
    @technologies = []
    levels = []
    # Build level partitions - ugly
    for tech in Technologies.models
      view = new TechnologyView(model: tech, parent: this)
      @technologies.push view
      index = tech.getLevel() - 1
      color = tech.getColor()
      levels[index] ?= {}
      levels[index][color] ?= $("<div class=\"#{color}\"></div>")
      levels[index][color].append view.render().el

    for level, index in levels
      el = $ "<div class=\"techlevel level-#{index + 1}\"></div>"
      for color in ['yellow','green','blue','red']
        el.append level[color]
      @elTree.append el

    _.delay @initPlumbing, 250
    this
