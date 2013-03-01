class ti3.Game extends Backbone.Model
  defaults:
    name: "Unnamed Game"
    token: null
    players: []
    expansionsInUse: ['se']
    optionalRulesInUse: ['shock_troops']

  initialize: ->
    if _.isArray @get("players")
      token = @getToken()
      @players = _.map @get("players"), (pObj) ->
        pObj.gameToken = token
        new ti3.Player(pObj)

  url: ->
    "/games/#{@getToken()}.json"

  getName: ->
    @get("name")

  getToken: ->
    @get("token")

  getPlayer: (number) ->
    _.find @players, (p) ->
      p.getNumber() is number

  usingExpansion: (code) ->
    code is "base" or @get("expansionsInUse").indexOf(code) > -1

  usingOptionalRule: (code) ->
    code is "none" or @get("optionalRulesInUse").indexOf(code) > -1

  update: ->
    @fetch
      success: (model, data) =>
        for pData in model.get('players')
          player = model.getPlayer(pData.number)
          player.set pData, silent: true
          player.refreshTechnologies()
        # Ping listeners for update
        @trigger('updated', model)
