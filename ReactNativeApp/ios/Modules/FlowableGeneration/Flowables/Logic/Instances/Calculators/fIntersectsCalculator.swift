//
//  fIntersectsCalculator.swift
//  Football433
//
//  Created by arham on 08/12/2021.
//

import Foundation

class fIntersectsCalculator: BaseLogic {
  /*
   BaseLocation -> DetectionLoction -> RectLocation
   Double
   ObjectState
   
   */
  var inputA: BasePort<IntersectionProtocol> = BasePort(name: "inputA", isDynamic: false, isOptional: false, isEndPort: false)
  var inputB: BasePort<IntersectionProtocol> = BasePort(name: "inputB", isDynamic: false, isOptional: false, isEndPort: false)
  
  var pass: BasePort<Logic> = BasePort(name: "pass", isDynamic: false, isOptional: false, isEndPort: false)
  var fail: BasePort<Logic> = BasePort(name: "fail", isDynamic: false, isOptional: false, isEndPort: false)
  
  weak var objectConnectedTo: BallController?
  
  @objc var intersection: String?
  
  var rangeLimit: Int = 15
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .TRIGGER)
    for inputPort in inputPorts {
      switch inputPort.port_sequence {
      case 1:
        inputA.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 2:
        inputB.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      default:
        continue
      }
    }
    
    for outputPort in outputPorts {
      switch outputPort.port_sequence {
      case 1:
        pass.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 2:
        fail.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
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
    guard let objectConnectedTo = self.objectConnectedTo else { return false }
    guard inputA.portIOType != .UNDEFINED, inputB.portIOType != .UNDEFINED else { return false }
    guard let objA: IntersectionProtocol = inputA.get() else { return false }
    guard let objB: IntersectionProtocol = inputB.get() else { return false }
    let intersects: Bool = objA.intersectsWith(b: objB)
    pass.set(val: Logic(intersects))
    fail.set(val: Logic(!intersects))
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.pass
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [inputA, inputB]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [pass, fail]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
}
