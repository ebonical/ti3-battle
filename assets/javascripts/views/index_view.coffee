class IndexView extends Backbone.View
  el: ".section#index"

  playerTemplate: _.template $(".section#index .new-game-view .player.template").html()

  events:
    "click a[href=#new-game]": "_newGameHandler"
    "click a[href=#join-game]": "_joinGameHandler"
    "click a[href=#close-new-game]": "_closeNewGameHandler"
    "click .form-actions button": "_submitFormHandler"
    "click a[href=#start-game]": "_startGameHandler"

  initialize: ->
    @elNewGame = @$el.find(".new-game-view")
    @elGameCreated = @$el.find(".game-created-view")

  reset: ->
    @_initNewGameForm()
    @render()


  _newGameHandler: (e) ->
    e.preventDefault()
    @toggleNewGameForm()

  _joinGameHandler: (e) ->
    e.preventDefault()

  _closeNewGameHandler: (e) ->
    e.preventDefault()
    @toggleNewGameForm(false)


  _initNewGameForm: ->
    html = ""
    for num in [1..8]
      html += @playerTemplate
        number: num
        color: 'random'
        raceId: 'random'
    @$el.find(".players").html html

  _submitFormHandler: (e) ->
    e.preventDefault()
    players = @serializeNewGameForm()
    if players.length > 1
      data =
        game:
          players_attributes: _.map(players, (p) -> p.toDbAttributes())
      $.ajax
        url: "/games"
        dataType: "json"
        data: data
        type: "POST"
        success: (data, textStatus, jqXHR) =>
          @_gameCreated(data)

  _startGameHandler: (e) ->
    e.preventDefault()
    App.openStartGame()

  _gameCreated: (data) ->
    @_setGame data.game
    @elNewGame.addClass "hide"
    @elGameCreated.removeClass "hide"
    @elGameCreated.find(".game-token").text state.game.getToken()

  _setGame: (gameData) ->
    state.game = new Game(gameData)


  toggleNewGameForm: (show) ->
    show ?= @elNewGame.hasClass("hide")
    @$el.find(".game-options").toggleClass "hide", show
    @elNewGame.toggleClass "hide", not show

  serializeNewGameForm: ->
    data = $.deparam @$el.find(".new-game-view form").serialize()
    players = []
    for playerData in data.player
      if playerData.name.trim().length > 0
        playerData.number = players.length + 1
        players.push new Player(playerData)
    # Assign randomised colours and races if needed
    colors = _.difference Data.colors, _.map(players, (p) -> p.getColor())
    races = _.difference _.map(Races.models, (r) -> r.id), _.map(players, (p) -> p.getRaceId())
    colors = _.shuffle colors
    races = _.shuffle races
    for player in players
      # check each player for "random" value
      if player.getRaceId() is "random"
        player.setRace races.shift()
      if player.getColor() is "random"
        player.setColor colors.shift()
    players


  render: ->
    this
