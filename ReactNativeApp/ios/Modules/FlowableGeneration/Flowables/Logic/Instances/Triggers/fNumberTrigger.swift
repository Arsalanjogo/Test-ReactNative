//
//  fNumberTrigger.swift
//  jogo
//
//  Created by arham on 30/11/2021.
//

import Foundation

class fNumberTrigger: BaseLogic {
  
  var number: BasePort<Number> = BasePort(name: "number", isDynamic: false, isOptional: false, isEndPort: false)
  
  @objc internal var initialValue: Double = 0
  
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts, tag: .TRIGGER)
    for outputPort in outputPorts {
      number.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
  }
  
  override func process() -> Bool {
    // TODO: Do the level fetching here.
    number.set(val: Number(initialValue))
    return true
  }
  
  func getResult() -> PortProtocol {
    // TODO: This does not work and should be made to be removed.
    return number
  }
  
  override func getInputPorts() -> [PortProtocol] {
    return []
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if number.portIOType != .UNDEFINED {
      retVal.append(number)
    }
    return retVal
  }
}
