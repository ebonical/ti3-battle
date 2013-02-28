class ti3.IndexView extends Backbone.View
  el: ".section#index"

  playerTemplate: _.template $(".section#index .new-game-view .player.template").html()

  events:
    "click a[href=#new-game]": "_newGameHandler"
    "click a[href=#join-game]": "_joinGameHandler"
    "click a[href=#readme]": "_readmeHandler"
    "click a[href=#close-new-game]": "_closeNewGameHandler"
    "click .form-actions button": "_submitFormHandler"
    "click a[href=#start-game]": "_startGameHandler"

  initialize: ->
    @elNewGame = @$el.find(".new-game-view")
    @elJoinGame = @$el.find(".join-game-view")
    @elGameCreated = @$el.find(".game-created-view")

  reset: ->
    # @_renderNewGameForm()
    @render()


  _newGameHandler: (e) ->
    e.preventDefault()
    @_renderNewGameForm()
    @toggleNewGameForm()

  _joinGameHandler: (e) ->
    e.preventDefault()
    @toggleJoinGameForm()

  _readmeHandler: (e) ->
    e.preventDefault()
    readme = $('.readme_overlay')
    content = readme.find('.content')
    readme.removeClass('hide')
    if content.html() == ''
      readme.addClass('loading')
      $.get "/readme", (data, textStatus, jqXHR) ->
        readme.removeClass('loading')
        readme.find('a.close-readme').click (e) ->
          e.preventDefault()
          readme.addClass('hide')
        content.html data

  _closeNewGameHandler: (e) ->
    e.preventDefault()
    @toggleNewGameForm(false)


  _renderNewGameForm: ->
    elPlayers = @$el.find(".players").html('')
    for num in [1..8]
      el = @playerTemplate
        number: num
        color: 'random'
        raceId: 'random'
      el = $(el)
      elPlayers.append el
      new ti3.PlayerFormInputView(el: el, form: this)

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
    history.pushState({}, "Game On", "/g/#{state.game.getToken()}")
    App.openStartGame()

  _gameCreated: (data) ->
    @_setGame data.game
    @elNewGame.addClass "hide"
    @elGameCreated.removeClass "hide"
    @elGameCreated.find(".game-token").text state.game.getToken()

  _setGame: (gameData) ->
    state.game = new ti3.Game(gameData)


  toggleNewGameForm: (show) ->
    show ?= @elNewGame.hasClass("hide")
    @$el.find(".game-options").toggleClass "hide", show
    @elNewGame.toggleClass "hide", not show

  toggleJoinGameForm: (show) ->
    @joinGameView ?= new ti3.JoinGameView(parent: this)
    show ?= not @joinGameView.isVisible()
    @$el.find(".game-options").toggleClass "hide", show
    @joinGameView.toggle show

  serializeNewGameForm: ->
    data = $.deparam @$el.find(".new-game-view form").serialize()
    players = []
    for playerData in data.player
      if playerData.name.trim().length > 0
        playerData.number = players.length + 1
        players.push new ti3.Player(playerData)
    # Assign randomised colours and races if needed
    colors = _.difference ti3.Data.colors, _.map(players, (p) -> p.getColor())
    races = _.difference _.map(ti3.Races.models, (r) -> r.id), _.map(players, (p) -> p.getRaceId())
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
