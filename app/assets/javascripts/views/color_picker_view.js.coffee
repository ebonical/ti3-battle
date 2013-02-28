# @options = {swatch, selected}
class ti3.ColorPickerView extends Backbone.View
  className: "color-picker fade"

  wrapperTemplate: _.template "<div class='swatches'>{{swatches}}</div>"

  swatchTemplate: _.template """
    <div class="color swatch {{color}} color{{index}}" data-color="{{color}}"><a href="#select-color"><span class="random">?</span></a></div>
  """

  events:
    "click a[href=#select-color]": "_selectColorHandler"

  initialize: ->
    @swatch = @options.swatch
    @colors = _.difference ti3.Data.colors.concat('random'), @getSelected()
    @render()
    @show()

  getSelected: ->
    @options.selected

  show: ->
    @$el.addClass "in"

  hide: ->
    @$el.remove()


  _selectColorHandler: (e) ->
    e.preventDefault()
    picked = $(e.target).closest('.swatch')
    color = picked.data('color')
    @swatch.removeClass @getSelected()
    @swatch.addClass color
    @swatch.data 'color', color
    @swatch.find('input').val color
    @hide()

  render: ->
    el = @$el
    swatches = ''
    for color, index in @colors.concat(@getSelected())
      swatches += @swatchTemplate
        color: color
        index: index
    el.html @wrapperTemplate(swatches: swatches)
    #
    @swatch.after el
    # position picker
    left = @swatch.position().left
    left += +@swatch.css('margin-left').replace('px','')
    el.css 'left', left
    this
