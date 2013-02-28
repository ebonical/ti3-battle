class ti3.OptionPickerView extends Backbone.View
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
    @options.callback.call this, value, @options.callbackArgs
    @hide()

  render: ->
    html = ''
    for option in @options.options
      value = option[0]
      isSelected = if value is @options.selected then 'selected' else ''
      html += @optionTemplate
        label: option[1]
        value: value
        isSelected: isSelected
    @$el.html html
    @show()
