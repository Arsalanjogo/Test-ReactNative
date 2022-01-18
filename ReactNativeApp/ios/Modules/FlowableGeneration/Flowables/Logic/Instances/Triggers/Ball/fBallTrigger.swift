//
//  fBallTrigger.swift
//  Football433
//
//  Created by arham on 08/12/2021.
//

import Foundation

//TODO: Make the whole logic here
class fBallTrigger: BaseLogic {
  
  var detectionObject: BasePort<BallState> = BasePort(name: "detectionLocation", isDynamic: false, isOptional: true, isEndPort: false)
  var x: BasePort<Number> = BasePort(name: "X", isDynamic: false, isOptional: true, isEndPort: false)
  var y: BasePort<Number> = BasePort(name: "Y", isDynamic: false, isOptional: true, isEndPort: false)
  var width: BasePort<Number> = BasePort(name: "width", isDynamic: false, isOptional: true, isEndPort: false)
  var height: BasePort<Number> = BasePort(name: "height", isDynamic: false, isOptional: true, isEndPort: false)
    
  weak var objectConnectedTo: BallController?
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .TRIGGER)
    for outputPort in outputPorts {
      switch outputPort.port_sequence {
      case 1:
        detectionObject.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 2:
        x.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 3:
        y.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 4:
        width.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 5:
        height.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      default:
        continue
      }
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    connectToObjects()
  }
  
  private func connectToObjects() {
    objectConnectedTo = GamePhase.getPhase()?.ball?.controller
  }
  
  override func process() -> Bool {
    if objectConnectedTo == nil {
      self.connectToObjects()
    }
    if detectionObject.portIOType != .UNDEFINED {
      detectionObject.set(val: objectConnectedTo?.getBallState())
    }
    
    if x.portIOType != .UNDEFINED {
      x.set(val: Number(objectConnectedTo?.getBallState().getX()))
    }
    
    if y.portIOType != .UNDEFINED {
      y.set(val: Number(objectConnectedTo?.getBallState().getY()))
    }
    if width.portIOType != .UNDEFINED {
      width.set(val: Number(objectConnectedTo?.getWidth()))
    }
    if height.portIOType != .UNDEFINED {
      height.set(val: Number(objectConnectedTo?.getHeight()))
    }
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.detectionObject
  }
  
  override func getInputPorts() -> [PortProtocol] {
    return []
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediatePorts: [PortProtocol] = [detectionObject, x, y, width, height]
    for port in intermediatePorts {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
}
