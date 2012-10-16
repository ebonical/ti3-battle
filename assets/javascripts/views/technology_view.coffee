class TechnologyView extends Backbone.View
  template: _.template $(".section#techtree .tech.template").html()

  events:
    "click a[href=#research]": "_researchTechHandler"

  initialize: ->
    # ...

  _researchTechHandler: (e) ->
    e.preventDefault()
    if state.player.hasTechnology(@model)
      state.player.removeTechnology @model
    else
      state.player.addTechnology @model

  render: ->
    @$el.html @template(@model.toJSON())
    this
