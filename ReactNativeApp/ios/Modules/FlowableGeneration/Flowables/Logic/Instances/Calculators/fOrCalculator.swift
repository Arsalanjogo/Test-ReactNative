//
//  fOrCalculator.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fOrCalculator: BaseLogic {
  
  var v1: [BasePort<FlblPrimitiveType>] = []
  var pass: BasePort<Logic> = BasePort(name: "pass", isDynamic: false, isOptional: false, isEndPort: false)
  var fail: BasePort<Logic> = BasePort(name: "fail", isDynamic: false, isOptional: false, isEndPort: false)
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .CALCULATOR)
    for (portIndex, inputPort) in inputPorts.enumerated() {
      let port: BasePort<FlblPrimitiveType> = BasePort(name: "condition\(portIndex+1)", isDynamic: true, isOptional: false, isEndPort: false)
      port.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      v1.append(port)
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
    let val: Bool = self.v1.map({ port in
      port.get()?.getBoolean() ?? false
    }).contains(false)
    pass.set(val: Logic(!val))
    fail.set(val: Logic(val))
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.pass
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    for v in v1 {
      if v.portIOType != .UNDEFINED {
        retVal.append(v)
      }
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
