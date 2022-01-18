//
//  fIncrementCalculator.swift
//  jogo
//
//  Created by arham on 30/11/2021.
//

import Foundation


class fIncrementCalculator: BaseLogic {
  
  var increment: BasePort<FlblPrimitiveType> = BasePort(name: "increment", isDynamic: false, isOptional: false, isEndPort: false)
  var reset: BasePort<FlblPrimitiveType> = BasePort(name: "reset", isDynamic: false, isOptional: true, isEndPort: true)
  var number: BasePort<Number> = BasePort(name: "number", isDynamic: false, isOptional: false, isEndPort: false)
  
  var incrementedValue: Double = 0
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .CALCULATOR)
    for inputPort in inputPorts {
      switch inputPort.port_sequence {
      case 1:
        increment.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 2:
        reset.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
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
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
  }
  
  override func process() -> Bool {
    if increment.get()?.getBoolean() ?? false {
      incrementedValue += 1
      number.set(val: Number(incrementedValue))
    }
    return true
  }
  
  override func endLogic() {
    if reset.get()?.getBoolean() ?? false {
      incrementedValue = 0.0
      number.set(val: Number(incrementedValue))
    }
  }
  
  func getResult() -> PortProtocol {
    return number
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if increment.portIOType != .UNDEFINED {
      retVal.append(increment)
    }
    if reset.portIOType != .UNDEFINED {
      retVal.append(reset)
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if number.portIOType != .UNDEFINED {
      retVal.append(number)
    }
    return retVal
  }
}
