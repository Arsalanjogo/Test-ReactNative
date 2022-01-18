//
//  fBallBottomTrigger.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation


class fBallBottomTrigger: BaseLogic {
  
  var output: BasePort<Number> = BasePort(name: "ballBottom", isDynamic: false, isOptional: false, isEndPort: false)
  weak var objectConnectedTo: BallController?
  
  var rangeLimit: Int = 15
  
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
    let _val = objectConnectedTo.getKnownLastN(locationCount: rangeLimit)?.get()
    let y: Double? = _val?.map({ detLoc in
      detLoc.getY()
    }).max()
    output.set(val: Number(y ?? 1))
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
