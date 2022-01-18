//
//  StateType.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation

public protocol StateType {
  func addObserver(stateObserver: StateObserverType)
  func removeObservers()
  func removeObserver(observerType: ObserverType)
  func notifyObservers()
}
