//
//  fDidBouceTrigger.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

//TODO: Make the whole logic here
class fDidBounceTrigger: BaseLogic {
  
  var output: BasePort<Logic> = BasePort(name: "didBounce", isDynamic: false, isOptional: false, isEndPort: false)
  weak var objectConnectedTo: BallController?
  
  var jumpId: Int = 0
  var axis: BallState.AXIS = .y
  
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
    objectConnectedTo = GamePhase.getPhase()?.ball?.controller
  }

  
  override func process() -> Bool {
    if objectConnectedTo == nil {
      self.connectToObjects()
    }
    guard let objectConnectedTo = self.objectConnectedTo else { return false }
    let jumpFrameId = objectConnectedTo.didBounce(orientation: .ANY, frameId: jumpId, axis: self.axis)
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
