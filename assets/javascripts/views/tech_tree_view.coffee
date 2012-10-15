class TechTreeView extends Backbone.View
  el: ".section#techtree"

  levelTemplate: _.template $('.section#techtree .techlevel.template').html()

  initialize: ->
    @elTree = @$el.find('.technologies')
    @levels = {}
    @render()

  renderPlumbing: ->
    tech.initPlumbing() for tech in Technologies.models


  render: ->
    @technologies = []
    # Build level partitions
    @levels = []
    for num in [1..10]
      @levels.push
        level: num
        yellow: ""
        green: ""
        blue: ""
        red: ""

    for tech in Technologies.models
      view = new TechnologyView(model: tech)
      @technologies.push view
      key = "level-#{tech.getLevel()}"
      @levels[tech.getLevel() - 1][tech.getColor()] += view.render().$el.html()

    for level in @levels
      @elTree.append @levelTemplate(level)

    _.delay @renderPlumbing, 250
    this
