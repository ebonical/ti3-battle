class AppView extends Backbone.View
  el: "body"

  events:
    "click .main-nav a[href=#battle]": "openBattleBoard"

  openBattleBoard: (e) ->
    e.preventDefault()
    $('.section.active').removeClass('active')
    $('.section#battle').addClass('active')
    state.battle = new Battle(combatType: "space")
    @battle ?= new BattleView(model: state.battle)
