//
//  BaseLogic.swift
//  jogo
//
//  Created by arham on 21/10/2021.
//

import Foundation
import RxSwift


class BaseLogic: NSObject, FlowableLogicProtocol, CleanupProtocol {
  
  internal var name: String
  internal var uid: String
  internal var tag: FlowableTag
  internal var inputPorts: [PortConnectionDefinition]
  internal var outputPorts: [PortConnectionDefinition]
  internal var options: [String: Any]?
  
  required init(name: String = "BaseLogic",
                uid: String = "BUID1",
                options: [String: Any]? = nil,
                inputPorts: [PortConnectionDefinition],
                outputPorts: [PortConnectionDefinition],
                tag: FlowableTag = .CALCULATOR) {
    self.name = name
    self.uid = uid
    self.tag = tag
    self.inputPorts = inputPorts
    self.outputPorts = outputPorts
    self.options = options
  }
  
  func initializeOptions(mirror: Mirror, childObject: AnyObject) {
    guard let options = self.options else {
      return
    }
    for property in mirror.children {
      guard let label = property.label else { continue }
      let _value = options[label]
      guard let value = _value else { continue }
      childObject.setValue(value, forKey: label)
    }
  }
  
  func initialize(inputs: [PortProtocol], outputs: [PortProtocol]) {}
  
  func validatePort() throws {}
  
  func process() -> Bool {
    return false
  }
  
  func endLogic() {
    
  }
  
  func cleanup() {
    self.inputPorts.removeAll()
    self.outputPorts.removeAll()
    self.options?.removeAll()
  }
  
  func getInputPorts() -> [PortProtocol] {
    return []
  }
  
  func getOutputPorts() -> [PortProtocol] {
    return []
  }
  
}
