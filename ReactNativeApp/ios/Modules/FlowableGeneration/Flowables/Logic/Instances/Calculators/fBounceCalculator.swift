//
//  fBounceCalculator.swift
//  Football433
//
//  Created by arham on 14/12/2021.
//

import Foundation


class fBounceCalculator: BaseLogic {
  
  var input: BasePort<BallState> = BasePort(name: "ball", isDynamic: false, isOptional: false, isEndPort: false)
  var output: BasePort<Logic> = BasePort(name: "bounced", isDynamic: false, isOptional: false, isEndPort: false)
  
  @objc var direction: Int = 0
  @objc var orientation: Int = 0
  @objc var threshold: Double = 0 // ???
  @objc var lookback: Int = 10
  
  weak var objectConnectedTo: BallController?
  
  var jumpId: Int = 0
  var axis: BallState.AXIS = .y
  var ballOrientation: BallState.ORIENTATION = .ANY
  
  
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
        input.setUidAndPortIO(uid: inputPort.port_id, portIOType: .INPUT)
      default:
        continue
      }
    }
    
    for outputPort in outputPorts {
      switch outputPort.port_sequence {
      case 1:
        output.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      default:
        continue
      }
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    connectToObjects()
    
    switch direction {
    case 1:
      axis = .x
    default:
      axis = .y
    }
    
    switch orientation {
    case 1:
      ballOrientation = .ANY
    case 2:
      ballOrientation = .LEFT
    default:
      ballOrientation = .RIGHT
    }
    self.objectConnectedTo?.getBallState().DETERMINE_BOUNCE_RANGE = self.lookback
  }
  
  private func connectToObjects() {
    objectConnectedTo = GamePhase.getPhase()?.ball?.controller
  }
  
  override func process() -> Bool {
    if objectConnectedTo == nil {
      self.connectToObjects()
    }
    guard let objectConnectedTo = self.objectConnectedTo else { return false }
    let jumpFrameId = objectConnectedTo.didBounce(orientation: self.ballOrientation, frameId: jumpId, axis: self.axis)
    if jumpFrameId > jumpId {
      output.set(val: Logic(true))
      jumpId = jumpFrameId
    } else {
      output.set(val: Logic(false))
    }
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.output
  }
  
  override func getInputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [input]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [output]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
  
  
}
