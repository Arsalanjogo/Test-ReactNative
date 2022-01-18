//
//  fPropertyCalculator.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

class fPropertyCalculator: BaseLogic {
  
  var trigger: BasePort<FlblPrimitiveType> = BasePort(name: "trigger", isDynamic: false, isOptional: false, isEndPort: false)
  var set: BasePort<FlblPrimitiveType> = BasePort(name: "set", isDynamic: false, isOptional: true, isEndPort: false)
  var increment: BasePort<FlblPrimitiveType> = BasePort(name: "increment", isDynamic: false, isOptional: true, isEndPort: false)
  var decrement: BasePort<FlblPrimitiveType> = BasePort(name: "decrement", isDynamic: false, isOptional: true, isEndPort: false)
  
  var outputTrigger: BasePort<Number> = BasePort(name: "outputTrigger", isDynamic: false, isOptional: false, isEndPort: false)
  var outputContinues: BasePort<Number> = BasePort(name: "outputCont", isDynamic: false, isOptional: false, isEndPort: false)
  
  @objc var number: Double = 0.0
  
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
        trigger.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 2:
        self.set.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 3:
        increment.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      case 4:
        decrement.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      default:
        continue
      }
    }
    
    for outputPort in outputPorts {
      switch outputPort.port_sequence {
      case 1:
        outputTrigger.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 2:
        outputContinues.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      default:
        continue
      }
    }
    
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
  }
  
  override func process() -> Bool {
    if set.portIOType != .UNDEFINED {
      if set.get() != nil  {
        self.number = self.set.get()?.getDouble() ?? self.number
      }
    }
    
    if increment.portIOType != .UNDEFINED {
      if increment.get() != nil  {
        self.number += self.increment.get()?.getDouble() ?? 0
      }
    }
    
    if decrement.portIOType != .UNDEFINED {
      if decrement.get() != nil  {
        self.number -= self.decrement.get()?.getDouble() ?? 0
      }
    }
    
    // if if iifififififififififififififif?????????????????????? @_@
    if trigger.portIOType != .UNDEFINED {
      if trigger.get() != nil {
        if trigger.get()?.getBoolean() ?? false {
          if outputTrigger.portIOType != .UNDEFINED {
            self.outputTrigger.set(val: Number(self.number))
          }
        }
      }
    }
    
    if outputContinues.portIOType != .UNDEFINED {
      self.outputContinues.set(val: Number(self.number))
    }

    return true
  }
  
  func getResult() -> PortProtocol {
    if trigger.get()?.getBoolean() ?? true {
      return self.outputTrigger
    } else {
      return self.outputContinues
    }
    
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if trigger.portIOType != .UNDEFINED {
      retVal.append(trigger)
    }
    if self.set.portIOType != .UNDEFINED {
      retVal.append(self.set)
    }
    if increment.portIOType != .UNDEFINED {
      retVal.append(increment)
    }
    if decrement.portIOType != .UNDEFINED {
      retVal.append(decrement)
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    if outputTrigger.portIOType != .UNDEFINED {
      retVal.append(outputTrigger)
    }
    if outputContinues.portIOType != .UNDEFINED {
      retVal.append(outputContinues)
    }
    return retVal
  }
}
