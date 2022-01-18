//
//  fDidJumpTrigger.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fDidJumpTrigger: BaseLogic {
  
  var output: BasePort<Logic> = BasePort(name: "didJump", isDynamic: false, isOptional: false, isEndPort: false)
  weak var objectConnectedTo: PersonController?
  
  var jumpId: Int = 0
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .TRIGGER)
    for outputPort in outputPorts {
      output.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    connectToObjects()
  }
  
  private func connectToObjects() {
    // TODO: Remove singleton and
    objectConnectedTo = GamePhase.getPhase()?.person?.controller
  }
  
  override func process() -> Bool {
    if objectConnectedTo == nil {
      self.connectToObjects()
    }
    guard let objectConnectedTo = self.objectConnectedTo else { return false }
    let jumpFrameId = objectConnectedTo.didJump(lastJumpFrameId: jumpId)
    if jumpFrameId > jumpId {
      output.set(val: Logic(true))
      jumpId = jumpFrameId
    } else {
      output.set(val: Logic(true))
    }
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.output
  }
  
  override func getInputPorts() -> [PortProtocol] {
    return []
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if output.portIOType != .UNDEFINED {
      retVal.append(output)
    }
    return retVal
  }
}
