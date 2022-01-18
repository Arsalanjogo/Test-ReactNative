//
//  fGetLevelTrigger.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fGetLevelTrigger: BaseLogic {
  
  var level: BasePort<Number> = BasePort(name: "level", isDynamic: false, isOptional: false, isEndPort: false)
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .TRIGGER)
    for outputPort in outputPorts {
      level.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    connectToObjects()
    
  }
  
  private func connectToObjects() {
    //TODO: Connect to LevelController
  }
  
  override func process() -> Bool {
    // TODO: Do the level fetching here.
    level.set(val: Number(1.0))
    return true
  }
  
  func getResult() -> PortProtocol {
    // TODO: This does not work and should be made to be removed.
    return level
  }
  override func getInputPorts() -> [PortProtocol] {
    return []
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if level.portIOType != .UNDEFINED {
      retVal.append(level)
    }
    return retVal
  }
}
