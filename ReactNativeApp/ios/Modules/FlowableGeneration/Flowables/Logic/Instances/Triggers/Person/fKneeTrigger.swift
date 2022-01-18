//
//  fKneeTrigger.swift
//  jogo
//
//  Created by arham on 28/11/2021.
//

import Foundation

class fKneeTrigger: BaseLogic {
  
  var output: BasePort<[DetectionLocation]> = BasePort(name: "kneeDetLocs", isDynamic: false, isOptional: false, isEndPort: false)
  weak var objectConnectedTo: ObjectDetectionState?
  
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
    if self.uid.lowercased().contains("l") {
      objectConnectedTo = GameContext.getContext()?.personState?.leftLeg?.knee
    } else {
      objectConnectedTo = GameContext.getContext()?.personState?.rightLeg?.knee
    }
  }
  
  override func process() -> Bool {
    if objectConnectedTo == nil {
      self.connectToObjects()
    }
    guard let objectConnectedTo = objectConnectedTo else { return false }

    output.set(val: objectConnectedTo.getLocations().getReversed() as Any)
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
