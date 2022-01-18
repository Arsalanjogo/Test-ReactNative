//
//  FlowableProtocol.swift
//  jogo
//
//  Created by arham on 21/10/2021.
//

import Foundation


protocol FlowableLogicProtocol: AnyObject {
  var name: String { get set }
  var uid: String { get set }
  var tag: FlowableTag { get set }
  func initialize(inputs: [PortProtocol], outputs: [PortProtocol])
  func process() -> Bool
  func endLogic()
  func getInputPorts() -> [PortProtocol]
  func getOutputPorts() -> [PortProtocol]
  func cleanup()
}
