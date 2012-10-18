class TechnologyView extends Backbone.View
  template: _.template $(".section#techtree .tech.template").html()

  events:
    "click .tech": "_clickSelf"
    "click a[href=#research]": "_researchTechHandler"

  initialize: ->
    @id = @model.id

  showPath: ->
    @options.parent.showPath @model

  showConnections: ->
    jsPlumb.show @model.id

  hideConnections: ->
    jsPlumb.hide @model.id

  _clickSelf: (e) ->
    e.preventDefault()
    @showPath()

  _researchTechHandler: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if state.player.hasTechnology(@model)
      state.player.removeTechnology @model
    else
      state.player.addTechnology @model

  render: ->
    @$el.html @template(@model.toJSON())
    this
