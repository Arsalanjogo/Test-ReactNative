//
//  fTimerTrigger.swift
//  jogo
//
//  Created by arham on 30/11/2021.
//

import Foundation

class fTimerTrigger: BaseLogic {
  
  var trigger: BasePort<Logic> = BasePort(name: "trigger", isDynamic: false, isOptional: false, isEndPort: false)
  
  var startTime: Double?
  var currentTime: Double?
  var elapsedTime: Int?
  
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .TRIGGER)
    for outputPort in outputPorts {
      trigger.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    
  }
  
  override func process() -> Bool {
    // TODO: Do the level fetching here.
    guard startTime != nil else {
      startTime = Date().getMilliseconds()
      trigger.set(val: Logic(false))
      return true
    }
    self.currentTime = Date().getMilliseconds()
    
    let val = Int(floor((self.currentTime! - self.startTime!)/1000.0))
    if elapsedTime == nil {
      self.elapsedTime = val
      trigger.set(val: Logic(false))
      return true
    }
    
    if val > self.elapsedTime! {
      self.elapsedTime = val
      trigger.set(val: Logic(true))
      return true
    }
    
    trigger.set(val: Logic(false))
    return true
  }
  
  func getResult() -> PortProtocol {
    // TODO: This does not work and should be made to be removed.
    return trigger
  }
  
  override func getInputPorts() -> [PortProtocol] {
    return []
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if trigger.portIOType != .UNDEFINED {
      retVal.append(trigger)
    }
    return retVal
  }
}
