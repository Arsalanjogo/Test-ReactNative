//
//  StateObserver.swift
//  jogo
//
//  Created by Mohsin on 12/10/2021.
//

import Foundation

public enum ObserverType {
  case Controller
  case View
}

public protocol StateObserverType {
  func onNotify()
  var type: ObserverType { get set }
}
