//
//  fGroundLine.swift
//  Football433
//
//  Created by arham on 08/12/2021.
//

//TODO: Make the whole logic here
import Foundation

class fGroundLineTrigger: BaseLogic {
  
  var movingObject: BasePort<RectLocation> = BasePort(name: "groundLine", isDynamic: false, isOptional: true, isEndPort: false)
  var x: BasePort<Number> = BasePort(name: "x", isDynamic: false, isOptional: true, isEndPort: false)
  var y: BasePort<Number> = BasePort(name: "y", isDynamic: false, isOptional: true, isEndPort: false)
  var width: BasePort<Number> = BasePort(name: "width", isDynamic: false, isOptional: true, isEndPort: false)
  var height: BasePort<Number> = BasePort(name: "height", isDynamic: false, isOptional: true, isEndPort: false)
  
  weak var leftAnkle: ObjectDetectionState?
  weak var rightAnkle: ObjectDetectionState?
  weak var person: PersonController?
  
  public required init(name: String,
                       uid: String,
                       options: [String: Any]?,
                       inputPorts: [PortConnectionDefinition],
                       outputPorts: [PortConnectionDefinition],
                       tag: FlowableTag) {
    super.init(name: name, uid: uid, options: options, inputPorts: inputPorts, outputPorts: outputPorts,  tag: .TRIGGER)
    for outputPort in outputPorts {
      switch outputPort.port_sequence {
      case 1:
        movingObject.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 2:
        x.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 3:
        y.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 4:
        width.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      case 5:
        height.setUidAndPortIO(uid: outputPort.port_id, portIOType: .OUTPUT)
      default:
        continue
      }
    }
    self.initializeOptions(mirror: Mirror(reflecting: self), childObject: self)
    connectToObjects()
    
  }
  
  private func connectToObjects() {
    leftAnkle = GameContext.getContext()?.personState?.leftLeg?.ankle
    rightAnkle = GameContext.getContext()?.personState?.rightLeg?.ankle
    person = GamePhase.getPhase()?.person?.controller
  }
  
  override func process() -> Bool {
    if leftAnkle == nil || rightAnkle == nil {
      self.connectToObjects()
    }
    guard let leftAnkle = leftAnkle else { return false }
    guard rightAnkle != nil else { return false }
    guard let person = person else { return false }
    
    let groundLineY: Double = person.getGroundLine()
    let detLoc: RectLocation = RectLocation(rect: CGRect(x: 0, y: groundLineY, width: 1, height: 1-groundLineY), classLabel: "groundLine", frameId: leftAnkle.getInfoBlobArrayList().get().last?.frameId ?? 0, confidence: 1.0)
    
    if movingObject.portIOType != .UNDEFINED {
      movingObject.set(val: detLoc)
    }
    
    if x.portIOType != .UNDEFINED {
      x.set(val: Number(0.0))
    }
    
    if y.portIOType != .UNDEFINED {
      y.set(val: Number(groundLineY))
    }
    
    if width.portIOType != .UNDEFINED {
      width.set(val: Number(1.0))
    }
    
    if height.portIOType != .UNDEFINED {
      height.set(val: Number(1.0 - groundLineY))
    }
    
    return true
  }
  
  func getResult() -> PortProtocol {
    return self.movingObject
  }
  
  override func getInputPorts() -> [PortProtocol] {
    return []
  }
  
  override func getOutputPorts() -> [PortProtocol] {
    var retVal: [PortProtocol] = []
    let intermediate: [PortProtocol] = [movingObject, x, y, width, height]
    for port in intermediate {
      if port.portIOType != .UNDEFINED {
        retVal.append(port)
      }
    }
    return retVal
  }
}
