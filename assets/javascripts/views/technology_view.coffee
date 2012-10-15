class TechnologyView extends Backbone.View

  template: _.template $(".section#techtree .tech.template").html()

  initialize: ->
    # ...

  render: ->
    @$el.html @template(@model.toJSON())
    this
