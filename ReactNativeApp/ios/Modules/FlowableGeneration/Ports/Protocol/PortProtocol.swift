//
//  PortProtocol.swift
//  jogo
//
//  Created by arham on 21/10/2021.
//

import Foundation

// Some stupid fuckery to get around not being able to use generic flowables.
// A better workaround for this: https://developer.apple.com/forums/thread/7350
// PATs as above but properly used. Makes everything much more difficult for me i.e. @Arham: https://www.youtube.com/watch?v=XWoNjiSPqI8
// Another good talk: https://www.youtube.com/watch?v=_m6DxTEisR8
// Why?
// We are assuming that all BasePorts are going to be inheriting from PortProtocol.
// PATs cannot be used as such -> Protocol 'PortProtocol' can only be used as a generic constraint because it has Self or associated type requirements
// So what this utter shit of a thing does is that force up-casting from BasePortProtocols to whatever classes are being inherited by PortProtocol.
// Fuck PAT for now... Will come back to it after I am done with CPs. Maybe generic protocols aren't the answer
// protocol PortPAT: PortProtocol {
//  typealias PortValue
//  func get() -> PortValue
//  func set(val: PortValue)
// }

// @Android team, Generic Interfaces are supported and are easy to implement over there so all of the force unwrapping
// shenanigens are not an issue on your side.
protocol PortProtocol: AnyObject {
  
  var isDynamic: Bool { get set }
  var isEnd: Bool { get set }
  var flowable_id: String { get set }
  var port_id: String { get set }
  var uid: String { get set }
  var portIOType: PortIOType { get set } 
  
  var isOptional: Bool { get set }
  
  func get_uid() -> String
  func set_uid(val: String)
  
  func get() -> Any
  func set(val: Any)
  func clear()
  func isNull() -> Bool
  
  func cleanup()
  
  func getDataFromConnectedPort() -> Bool
  
  func set_port_type(portIOType: PortIOType)
  
  func set_base_flowable(flowable: Flowable)
  func get_base_flowable() -> Flowable
  
  var nextPortReference: [PortProtocol] { get set }
  var previousPortReference: PortProtocol? { get set }
  func set_port_reference(port: PortProtocol, portType: PortIOType)
}
