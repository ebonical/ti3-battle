class PlayerFormInputView extends Backbone.View

  events:
    "click a[href=#pick-color]": "_pickColorHandler"
    "click a[href=#pick-race]": "_pickRaceHandler"

  initialize: ->
    @form = @options.form
    @number = @$el.data('number')
    @swatch = @$el.find('.swatch')
    @race = @$el.find('.race')
    @currentColor = @swatch.data('color')
    @currentRace = @race.data('race')

  _pickColorHandler: (e) ->
    e.preventDefault()
    if @form.colorPicker?
      @form.colorPicker.hide()
    @currentColor = @swatch.data('color')
    @form.colorPicker = new ColorPickerView
      swatch: @swatch
      selected: @currentColor

  _pickRaceHandler: (e) ->
    e.preventDefault()
    new OptionPickerView
      title: 'Select Race'
      options: _.map(Races.models.concat('random'), (r) ->
                if _.isString(r) then [r, 'Random race'] else [r.id, r.getName()])
      selected: @currentRace
      callback: @_selectOptionRace

  _selectOptionRace: (selectedRaceId) =>
    @race.removeClass @currentRace
    @race.addClass selectedRaceId
    @currentRace = selectedRaceId

    found = Races.get(selectedRaceId)

    @race.data 'race', @currentRace
    @race.find('input').val @currentRace
    @race.find('a').text(if found? then found.getName() else "Random race")

  render: ->
    this
