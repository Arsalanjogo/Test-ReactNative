//
//  fNumberCalculator.swift
//  Football433
//
//  Created by arham on 10/12/2021.
//

import Foundation


class fNumberCalculator: BaseLogic {
  
  private var increment: BasePort<FlblPrimitiveType> = BasePort(name: "increment", isDynamic: false, isOptional: true, isEndPort: true)
  private var setter: BasePort<FlblPrimitiveType> = BasePort(name: "set", isDynamic: false, isOptional: true, isEndPort: true)
  private var forward: BasePort<FlblPrimitiveType> = BasePort(name: "forward", isDynamic: false, isOptional: false, isEndPort: false)
  
  private var number: BasePort<Number> = BasePort(name: "number", isDynamic: false, isOptional: false, isEndPort: false)
  
  private var numberValue: Double = 0
  @objc var initialValue: Double = 0
  @objc var incrementBy: Double = 1
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .CALCULATOR)
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    for inputPort in inputPorts {
      switch inputPort.port_sequence {
      case 1:
        increment.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 2:
        setter.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 3:
        forward.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      default:
        continue
      }
    }
    
    for outputPort in outputPorts {
      switch outputPort.port_sequence {
      case 1:
        number.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      default:
        continue
      }
    }
    numberValue = initialValue
  }
  
  func incrementValue() {
    guard let incrementableValue = increment.get()?.getDouble() else { return }
    numberValue += incrementableValue
    increment.clear()
    number.set(val: Number(numberValue))
  }
  
  func setterValue() {
    guard let setValue = setter.get()?.getDouble() else { return }
    numberValue = setValue
    setter.clear()
    number.set(val: Number(0))
  }
  
  func forwardValue() {
    guard let forwardValue = forward.get()?.getBoolean() else { return }
    if forwardValue {
      number.set(val: Number(numberValue))
    } else {
      number.clear()
    }
  }
  
  override func process() -> Bool {
    if forward.portIOType != .UNDEFINED {
      forwardValue()
    }
    return true
  }
  
  override func endLogic() {
    if increment.portIOType != .UNDEFINED {
      incrementValue()
    }
    
    if setter.portIOType != .UNDEFINED {
       setterValue()
    }
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [increment, setter, forward]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [number]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
  
}
