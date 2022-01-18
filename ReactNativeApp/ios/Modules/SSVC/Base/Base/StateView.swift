//
//  StateView.swift
//  jogo
//
//  Created by Mohsin on 12/10/2021.
//

import Foundation

public class StateView: StateViewType {
  
  public func cleanup() {
  }
  
}

// MARK: Debug Text Extension
extension StateView: DebugText {
  @objc public func getDebugText() -> String { return "" }
}
