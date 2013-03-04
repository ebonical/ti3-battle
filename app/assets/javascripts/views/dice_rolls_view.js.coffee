class ti3.DiceRollsView extends Backbone.View
  tagName: "span"
  className: "rolls"

  hitTemplate: _.template('<span class="hit">{{value}}</span>')
  missTemplate: _.template('<span class="miss">{{value}}</span>')
  rerollTemplate: _.template('<span class="reroll">({{value}})</span>')

  render: ->
    rolls = @options.rolls
    results = []
    for roll in rolls
      data = { value: roll.value }
      if roll.reroll
        data.value = data.value + @rerollTemplate(value: roll.reroll)

      if roll.hit
        results.push @hitTemplate(data)
      else
        results.push @missTemplate(data)
    @$el.html results.join(", ")
    this
