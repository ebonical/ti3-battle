class TechTreeView extends Backbone.View
  el: ".section#techtree"

  levelTemplate: _.template $('.section#techtree .techlevel.template').html()

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
    if @_playerChanged()
      @currentPlayerNumber = state.player.getNumber()
      @_refreshTechnologies(state.player)

  _playerChanged: ->
    state.player? and state.player.getNumber() != @currentPlayerNumber

  _refreshTechnologies: (player) ->
    if player.getNumber() is @currentPlayerNumber
      @$el.find('.tech').removeClass 'researched'
      ids = _.map(player.getTechnologyIds(), (id) -> "##{id}").join(', ')
      $(ids).addClass 'researched'

  initPlumbing: ->
    tech.initPlumbing() for tech in Technologies.models
    # repaint to make sure all connections are sound
    jsPlumb.repaintEverything()

  render: ->
    @technologies = []
    levels = []
    # Build level partitions - ugly
    for tech in Technologies.models
      view = new TechnologyView(model: tech)
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
