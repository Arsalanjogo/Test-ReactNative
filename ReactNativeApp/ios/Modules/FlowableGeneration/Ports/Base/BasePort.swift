//
//  BasePort.swift
//  jogo
//
//  Created by arham on 20/10/2021.
//

import Foundation

enum PortIOType {
  case UNDEFINED
  case INPUT
  case OUTPUT
}

class BasePort<PortType: Any>: PortProtocol {
  
  var isOptional: Bool = false
  var isDynamic: Bool
  var isEnd: Bool
  
  var name: String = ""
  
  var flowable_id: String = ""
  var port_id: String = ""
  var portIOType: PortIOType = .UNDEFINED
  weak var currentFlowableReference: Flowable?
  var nextPortReference: [PortProtocol] = []
  var previousPortReference: PortProtocol?

  func get() -> Any {
    return self.value as Any
  }
  
  func set(val: Any) {
    self.value = val as! PortType?
  }
  
  func clear() {
    self.value = nil
  }
  
  func isNull() -> Bool {
    return (self.value == nil)
  }
  
  func isEndPort() -> Bool {
    return self.isEnd
  }
  
  public typealias PortValue = PortType
  
  internal var value: PortType?
  internal var uid: String = ""
  
  init(name: String = "", isDynamic: Bool = false, isOptional: Bool = false, isEndPort: Bool = false) {
    self.name = name
    self.isDynamic = isDynamic
    self.isOptional = isOptional
    self.isEnd = isEndPort
  }
  
  init(uid: String, flowable_id: String, port_id: String, isDyanmic: Bool = false, isOptional: Bool = false, isEndPort: Bool = false) {
    self.uid = uid
    self.flowable_id = flowable_id
    self.port_id = port_id
    self.isDynamic = isDyanmic
    self.isOptional = isOptional
    self.isEnd = isEndPort
    
  }
  
  func get_uid() -> String {
    return self.uid
  }
  
  func set_uid(val: String) {
    self.uid = val
    let intermediate = uid.split(separator: "_")
    self.flowable_id = String(intermediate.first!)
    self.port_id = String(intermediate.last!)
  }
  
  func setUidAndPortIO(uid: String, portIOType: PortIOType) {
    self.set_uid(val: uid)
    self.set_port_type(portIOType: portIOType)
  }
  
  func set_port_type(portIOType: PortIOType) {
    self.portIOType = portIOType
  }
  
  func get() -> PortValue? {
    return self.value
  }
  
  func set(val: PortValue) {
    self.value = val
  }
  
  func getDataFromConnectedPort() -> Bool {
    let value: PortType? = self.previousPortReference!.get() as? PortType
    if value == nil { return false }
    self.set(val: value)
    return true
  }
  
  func set_base_flowable(flowable: Flowable) {
    self.currentFlowableReference = flowable
  }
  
  func get_base_flowable() -> Flowable {
    return self.currentFlowableReference!
  }
  
  func set_port_reference(port: PortProtocol, portType: PortIOType) {
    switch portType {
    case .UNDEFINED:
      return
    case .INPUT:
      self.previousPortReference = port
    case .OUTPUT:
      self.nextPortReference.append(port)
    }
  }
  
  func cleanup() {
    self.nextPortReference.removeAll()
    self.previousPortReference = nil
    self.currentFlowableReference = nil
  }
}
