class AppView extends Backbone.View
  el: "body"

  events:
    "click .main-nav a[href=#battle]": "openBattleBoard"

  openBattleBoard: (e) ->
    e.preventDefault()
    $('.section.active').removeClass('active')
    $('.section#battle').addClass('active')
    @battle ?= new BattleView
