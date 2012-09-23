class DiceRollsView extends Backbone.View
  tagName: "span"
  className: "rolls"

  hitTemplate: _.template('<span class="hit">{{value}}</span>')
  missTemplate: _.template('<span class="miss">{{value}}</span>')

  render: ->
    rolls = @options.rolls
    hit = @options.hit
    console.log  rolls
    console.log hit
    console.log @$el

    results = []
    for roll in rolls
      if roll >= hit
        results.push @hitTemplate(value: roll)
      else
        results.push @missTemplate(value: roll)
    @$el.html results.join(", ")
    this