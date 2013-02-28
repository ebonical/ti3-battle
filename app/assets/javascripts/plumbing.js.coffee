# Source: BottomCenter
# Target: TopCenter
# jsPlumb.importDefaults
#   ConnectionOverlays: [
#     [ "Arrow", { location: 1, foldback: 0.9, width: 12, length: 10, paintStyle: {fillStyle:'#f00'} } ]
#   ]

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


ti3.Plumbing =
  arrowOverlayStyle:
    location: 1
    foldback: 0.9
    width: 12
    length: 10
    paintStyle:
      fillStyle: "#444"
      strokeStyle: "#444"

  plumbingConnector: plumbingConnector

  sourceEndpoint:
    isSource: true
    endpoint: "Blank"
    maxConnections: -1
    connector: plumbingConnector
    connectorStyle:
      lineWidth: 2
      strokeStyle: "#444"
      joinstyle: "miter"
      outlineColor: "white"
      outlineWidth: 2

  targetEndpoint:
    isTarget: true
    endpoint: "Blank"
    maxConnections: -1
