//
//  ContextPhaseDelegate.swift
//  jogo
//
//  Created by arham on 19/11/2021.
//

import Foundation

protocol ContextPhaseDelegate: AnyObject {
  func removeGamePhase()
  func insertGamePhase(value: GamePhasesName?)
}
