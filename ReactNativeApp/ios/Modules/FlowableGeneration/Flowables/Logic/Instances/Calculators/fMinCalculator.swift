//
//  fMinCalculator.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fMinCalculator: BaseLogic {
  
  var inputs: [BasePort<FlblPrimitiveType>]!
  var output: BasePort<Number> = BasePort(name: "output", isDynamic: false, isOptional: false, isEndPort: false)
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .CALCULATOR)
    
    inputs = []
    for (portIndex, inputPort) in inputPorts.enumerated() {
      let port: BasePort<FlblPrimitiveType> = BasePort(name: "number\(portIndex+1)", isDynamic: true, isOptional: false, isEndPort: false)
      port.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      inputs.append(port)
    }
    
    for outputPort in outputPorts {
      output.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
  }
  
  override func process() -> Bool {
    let val: Double = self.inputs.map ({ port in
      port.get()?.getDouble() ?? Double.infinity
    }).min() ?? -1
    if val == -1 {
      return false
    }
    output.set(val: Number(val))
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.output
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    for v in inputs {
      if v.portIOType != .UNDEFINED {
        retVal.append(v)
      }
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if output.portIOType != .UNDEFINED {
      retVal.append(output)
    }
    return retVal
  }
}
