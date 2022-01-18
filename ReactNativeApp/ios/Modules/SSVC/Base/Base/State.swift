//
//  State.swift
//  jogo
//
//  Created by Mohsin on 12/10/2021.
//

import Foundation

public class State: StateType, CleanupProtocol {
  private let stateObservers = UtilArrayList<StateObserverType>()
  
  /// To add new observer to a State
  public func addObserver(stateObserver: StateObserverType) {
    _ = stateObservers.add(value: stateObserver)
  }
  
  public func removeObservers() {
    stateObservers.clear()
  }
  
  public func removeObserver(observerType: ObserverType) {
    stateObservers.filter {
      $0.type == observerType
    }
  }
  
  /// To notify all existing observers of the State
  public func notifyObservers() {
    stateObservers.get().forEach({ $0.onNotify() })
  }
  
  public func cleanup() {
    self.stateObservers.clear()
  }
}


// MARK: Debug Text Extension
extension State: DebugText {
  @objc public func getDebugText() -> String { return "" }
}
