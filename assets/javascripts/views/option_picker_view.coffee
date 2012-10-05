class OptionPickerView extends Backbone.View
  className: "option-picker fade modal"

  optionTemplate: _.template '<div class="option {{isSelected}}" data-value="{{value}}"><a href="#select-option">{{label}}</a></div>'

  events:
    "click a[href=#select-option]": "_selectOptionHandler"

  initialize: ->
    @$el.on "hidden", =>
      @$el.remove()
    @render()

  show: ->
    @$el.modal()

  hide: ->
    @$el.modal('hide')

  _selectOptionHandler: (e) ->
    e.preventDefault()
    value = $(e.target).closest('.option').data('value')
    @options.callback.call this, +value
    @hide()

  render: ->
    html = ''
    for label, index in @options.labels
      value = @options.values[index]
      isSelected = if value is @options.selected then 'selected' else ''
      html += @optionTemplate
        label: label
        value: value
        isSelected: isSelected
    @$el.html html
    @show()
