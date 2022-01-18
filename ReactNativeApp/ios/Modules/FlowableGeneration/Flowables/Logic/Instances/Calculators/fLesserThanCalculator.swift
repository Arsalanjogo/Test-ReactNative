//
//  fLesserThanCalculator.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fLesserThanCalculator: BaseLogic {
  
  var v1: BasePort<FlblPrimitiveType> = BasePort(name: "v1", isDynamic: false, isOptional: false, isEndPort: false)
  var v2: BasePort<FlblPrimitiveType> = BasePort(name: "v2", isDynamic: false, isOptional: false, isEndPort: false)
  var pass: BasePort<Logic> = BasePort(name: "pass", isDynamic: false, isOptional: false, isEndPort: false)
  var fail: BasePort<Logic> = BasePort(name: "fail", isDynamic: false, isOptional: false, isEndPort: false)
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .CALCULATOR)
    for inputPort in inputPorts {
      switch inputPort.port_sequence {
      case 1:
        v1.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 2:
        v2.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
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
  }
  
  override func process() -> Bool {
    let val: Bool = (self.v1.get()?.getDouble() ?? 1 < self.v2.get()?.getDouble() ?? 0)
    pass.set(val: Logic(val))
    fail.set(val: Logic(!val))
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.pass
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if v1.portIOType != .UNDEFINED {
      retVal.append(v1)
    }
    if v2.portIOType != .UNDEFINED {
      retVal.append(v2)
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if pass.portIOType != .UNDEFINED {
      retVal.append(pass)
    }
    if fail.portIOType != .UNDEFINED {
      retVal.append(fail)
    }
    return retVal
  }
}
