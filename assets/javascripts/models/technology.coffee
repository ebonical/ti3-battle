class window.Technology extends Backbone.Model
  @maxLevel = 1

  initialize: ->
    @modifiers = []
    for data in (@get("modifiers") || [])
      @modifiers.push new Modifier(data)

  getAndOr: ->
    andor = @get("andor") or "or"
    andor = "or" if @getPrerequisiteIds().length <= 1
    andor

  getColor: ->
    @get 'color'

  getPlumbing: ->
    @get('plumbing') or {}

  getPrerequisiteIds: ->
    @get("prerequisites") or []

  getPrerequisites: ->
    return @_prerequisites if @_prerequisites?
    results = []
    for techId in @getPrerequisiteIds()
      tech = @collection.get(techId)
      results.push(tech) if tech?
    @_prerequisites = results

  getDependents: ->
    return @_dependents if @_dependents?
    results = []
    for tech in @collection.models
      if _.include tech.getPrerequisiteIds(), @id
        results.push tech
    @_dependents = results

  getAncestorsAndSelf: ->
    @_ancestors = []
    @_pre(this)

  _pre: (tech) ->
    @_ancestors.push tech
    @_pre(prereq) for prereq in tech.getPrerequisites()
    @_ancestors

  getLevel: ->
    return @_level if @_level?
    l = 1
    prereqs = @getPrerequisites()
    if prereqs.length > 0
      l = _.max(_.map(prereqs, (prereq) -> prereq.getLevel())) + 1
    if l > Technology.maxLevel
      Technology.maxLevel = l
    @_level = l

  hasModifiers: ->
    @modifiers.length > 0

  toJSON: ->
    obj = super
    obj.level = @getLevel()
    obj


  _sourceEndpoint: (target) ->
    defaultStub = plumbingConnector[1].stub
    defaultGap = plumbingConnector[1].gap

    stubs = @getPlumbing().stubs or {}
    stub = stubs[target.id] or @getPlumbing().stub or defaultStub

    color = if target.getAndOr() is "and" then "#C00" else "#444"
    arrowOverlayStyle.paintStyle =
      fillStyle: color
      strokeStyle: color

    _.extend {}, sourceEndpoint,
      connector: [
        "Flowchart"
        stub: stub
        gap: defaultGap
      ]
      connectorOverlays: [["Arrow", arrowOverlayStyle]]


  initPlumbing: ->
    for target, index in @getDependents()
      sourceId = "source-#{@id}-#{index}"
      targetId = "target-#{@id}-#{index}"

      anchors = @getPlumbing().anchorsOut or {}
      anchor = switch anchors[target.id]
        when 'Left' then [0.25, 1, 0, 1]
        when 'Right' then [0.75, 1, 0, 1]
        else 'BottomCenter'

      # End point for *this* technology
      jsPlumb.addEndpoint @id, @_sourceEndpoint(target),
        anchor: anchor
        uuid: sourceId

      anchors = target.getPlumbing().anchorsIn or {}
      anchor = switch anchors[@id]
        when 'Left' then [0.25, 0, 0, -1]
        when 'Right' then [0.75, 0, 0, -1]
        else 'TopCenter'

      # Target is dependent on this technology
      jsPlumb.addEndpoint target.id, targetEndpoint,
        anchor: anchor
        uuid: targetId

      jsPlumb.connect uuids: [sourceId, targetId]
  # end initPlumbing
