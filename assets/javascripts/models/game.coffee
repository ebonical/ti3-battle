class window.Game extends Backbone.Model
  defaults:
    name: "Unnamed Game"
    token: null
    players: []

  initialize: ->
    if _.isArray @get("players")
      token = @getToken()
      @players = _.map @get("players"), (pObj) ->
        pObj.gameToken = token
        new Player(pObj)

  url: ->
    "/g/#{@getToken()}.json"

  getName: ->
    @get("name")

  getToken: ->
    @get("token")

  getPlayer: (number) ->
    _.find @players, (p) ->
      p.getNumber() is number

  update: ->
    @fetch
      success: (model, data) ->
        for pData in model.get('players')
          player = model.getPlayer(pData.number)
          player.set pData, silent: true
          player.refreshTechnologies()
