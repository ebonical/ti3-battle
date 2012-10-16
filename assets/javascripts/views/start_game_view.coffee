# @model is the current game
class StartGameView extends Backbone.View
  el: ".section#start"

  playerTemplate: _.template $('.section#start .player.template').html()

  events:
    "click a[href=#select-player]": "_selectPlayerHandler"

  initialize: ->
    @render()

  selectPlayer: (number) ->
    state.player = @model.getPlayer(number)
    App.openDashboard()


  _selectPlayerHandler: (e) ->
    e.preventDefault()
    target = $(e.target).closest('a')
    number = target.attr('id').split('-')[1]
    @selectPlayer +number

  _renderPlayers: ->
    html = ''
    for player in @model.players
      obj = player.toJSON()
      obj.active = if state.player? && state.player.id is player.id then 'active' else ''
      html += @playerTemplate obj
    @$el.find(".players").html html

  render: ->
    @_renderPlayers()
    this
