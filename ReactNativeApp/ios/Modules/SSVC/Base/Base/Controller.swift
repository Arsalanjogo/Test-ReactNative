//
//  Controller.swift
//  jogo
//
//  Created by Mohsin on 12/10/2021.
//

import Foundation

public class Controller: ControllerType, StateObserverType, CleanupProtocol {
  internal var state: State?
  public var type: ObserverType = .Controller
  
  init(state: State) {
    self.state = state
    self.state?.addObserver(stateObserver: self)
  }
  
  public func onNotify() {}
  
  public func removeSVs(){}
  
  public func cleanup() {
    self.state = nil
  }
  
}


// MARK: Debug Text Extension
extension Controller: DebugText {
  @objc public func getDebugText() -> String { return "" }
}
