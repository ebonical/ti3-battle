class IndexView extends Backbone.View
  el: ".section#index"

  playerTemplate: _.template $(".section#index .new-game-form .player.template").html()

  events:
    "click a[href=#new-game]": "newGameHandler"
    "click a[href=#join-game]": "joinGameHandler"
    "click a[href=#close-new-game]": "closeNewGameHandler"
    "click .form-actions button": "submitFormHandler"


  newGameHandler: (e) ->
    e.preventDefault()
    @_toggleNewGameForm()

  joinGameHandler: (e) ->
    e.preventDefault()

  closeNewGameHandler: (e) ->
    e.preventDefault()
    @_toggleNewGameForm(false)

  submitFormHandler: (e) ->
    e.preventDefault()
    players = @_serializeNewGameForm()
    if players.length > 1
      data =
        game:
          players_attributes: _.map(players, (p) -> p.toDbAttributes())
      $.ajax
        url: "/games"
        dataType: "json"
        data: data
        type: "POST"
        success: (data, textStatus, jqXHR) ->
          console.log data

  _toggleNewGameForm: (show) ->
    elForm = @$el.find(".new-game-form")
    show ?= elForm.hasClass("hide")
    @$el.find(".game-options").toggleClass "hide", show
    elForm.toggleClass "hide", not show

  _serializeNewGameForm: ->
    data = $.deparam @$el.find(".new-game-form form").serialize()
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
    html = ""
    for player in Players.models
      html += @playerTemplate(player.toJSON())
    @$el.find(".players").html html
    this
