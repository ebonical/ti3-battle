# Source: BottomCenter
# Target: TopCenter
# jsPlumb.importDefaults
#   ConnectionOverlays: [
#     [ "Arrow", { location: 1, foldback: 0.9, width: 12, length: 10, paintStyle: {fillStyle:'#f00'} } ]
#   ]

arrowOverlayStyle =
  location: 1
  foldback: 0.9
  width: 12
  length: 10
  paintStyle:
    fillStyle: "#444"
    strokeStyle: "#444"

plumbingConnector = [
  "Flowchart"
  stub: [15,15]
  gap: 3
]

plumbingConnectorStyle =
  lineWidth: 2
  strokeStyle: "#444"
  joinstyle: "miter"
  outlineColor: "white"
  outlineWidth: 2

sourceEndpoint =
  isSource: true
  endpoint: "Blank"
  maxConnections: -1
  # paintStyle:
  #   fillStyle: "#225588"
  #   radius: 3
  connector: plumbingConnector
  connectorStyle: plumbingConnectorStyle

targetEndpoint =
  isTarget: true
  endpoint: "Blank"
  maxConnections: -1
  # paintStyle:
  #   fillStyle: "#558822"
  #   radius: 3

allSourceEndpoints = []
allTargetEndpoints = []

# window.plumbingAddEndpoint = (tId, options) ->
#   sourceOptions = _.extend {}, sourceEndPoint,
#     anchor: 'BottomCenter'
#     uuid: "source-#{tId}"

#   targetOptions = _.extend {}, targetEndPoint,
#     anchor: 'TopCenter'
#     uuid: "target-#{tId}"

#   allSourceEndpoints.push jsPlumb.addEndpoint tId, sourceOptions
#   allTargetEndpoints.push jsPlumb.addEndpoint tId, targetOptions


# addEndpoint('antimass-deflectors')
# addEndpoint('cybernetics')
# jsPlumb.connect({uuids:['source-antimass-deflectors','target-cybernetics']})
# jsPlumb.connect({uuids:['source-antimass-deflectors','target-xrd-transporters']})
