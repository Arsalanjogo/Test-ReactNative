//
//  fScoreAction.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fScoreAction: BaseLogic {
  
  var increment: BasePort<FlblPrimitiveType> = BasePort(name: "increment", isDynamic: false, isOptional: true, isEndPort: false)
  var decrement: BasePort<FlblPrimitiveType> = BasePort(name: "decrement", isDynamic: false, isOptional: true, isEndPort: false)
  var reset: BasePort<FlblPrimitiveType> = BasePort(name: "reset", isDynamic: false, isOptional: true, isEndPort: true)
  
  weak var objectConnectedTo: PointsController?
  
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .ACTION)
    for inputPort in inputPorts {
      switch inputPort.port_sequence {
      case 1:
        increment.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 2:
        decrement.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 3:
        reset.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      default:
        continue
      }
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    connectToObjects()
    
  }
  
  private func connectToObjects() {
    objectConnectedTo = GamePhase.getPhase()?.points?.controller
  }
  
  private func incrementPoints() {
    if increment.get() != nil {
      objectConnectedTo?.incrementPoints(value: increment.get()?.getInt() ?? 0)      
      increment.clear()
    }
  }
  
  private func decrementPoints() {
    if decrement.get() != nil {
      objectConnectedTo?.decrementPoints(value: decrement.get()?.getInt() ?? 0)
      decrement.clear()
    }
  }
  
  override func process() -> Bool {
    if objectConnectedTo == nil {
      self.connectToObjects()
    }
    guard objectConnectedTo != nil else { return false }
    
    if increment.portIOType != .UNDEFINED {
      incrementPoints()
    }
    
    if decrement.portIOType != .UNDEFINED {
      decrementPoints()
    }
    
    return true
  }
  
  override func endLogic() {
    if objectConnectedTo == nil {
      self.connectToObjects()
    }
    guard let objectConnectedTo = objectConnectedTo else { return }
    
    if reset.portIOType != .UNDEFINED {
      if reset.get()?.getBoolean() ?? false {
        objectConnectedTo.decrementPoints(value: objectConnectedTo.getPoints())
      }
    }
  }
  
  
  
  func getResult() -> PortProtocol {
    // TODO: This does not work and should be made to be removed.
    return increment
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [increment, decrement, reset]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    return []
  }
}
