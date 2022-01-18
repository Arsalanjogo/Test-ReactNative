//
//  fGetXCalculator.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fGetXCalculator: BaseLogic {
  
  var inputs: BasePort<[DetectionLocation]> = BasePort(name: "inputs", isDynamic: false, isOptional: false, isEndPort: false)
  var output: BasePort<[Number]> = BasePort(name: "output", isDynamic: false, isOptional: false, isEndPort: false)
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .CALCULATOR)
    for inputPort in inputPorts {
      inputs.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
    }
    for outputPort in outputPorts {
      output.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
  }
  
  override func process() -> Bool {
    output.set(val: self.inputs.get()?.map({ detLoc in
      Number(detLoc.getX())
    }))
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.output
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if inputs.portIOType != .UNDEFINED {
      retVal.append(inputs)
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
