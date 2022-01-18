//
//  fSetGlobalAction.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation


class fSetGlobalAction: BaseLogic {
  
  var valueRef: BasePort<FlblPrimitiveType> = BasePort(name: "valueRef", isDynamic: false, isOptional: false, isEndPort: false)
  
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .ACTION)
    for inputPort in inputPorts {
      valueRef.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
  }
  
  override func process() -> Bool {
    // TODO: Set the value to wherever you want to over here??
    return true
  }
  
  func getResult() -> PortProtocol {
    return valueRef
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if valueRef.portIOType != .UNDEFINED {
      retVal.append(valueRef)
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    return []
  }
}
