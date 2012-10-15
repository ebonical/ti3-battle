class JoinGameView extends Backbone.View
  el: ".section#index .join-game-view"

  events:
    'click a[href=#close-join-game]': '_closeViewHandler'
    'click button': '_submitFormHandler'

  toggle: (show) ->
    @$el.toggleClass 'hide', not show

  isVisible: ->
    @$el.is(':visible')

  _closeViewHandler: (e) ->
    e.preventDefault()
    @options.parent.toggleJoinGameForm(false)

  _submitFormHandler: (e) ->
    e.preventDefault()
    token = @$el.find('form input[name=game-token]').val()
    state.game = new Game(token: token)
    state.game.fetch
      success: (model, data) =>
        model.initialize()
        App.openStartGame()
      error: (model, data) ->
        # ...
