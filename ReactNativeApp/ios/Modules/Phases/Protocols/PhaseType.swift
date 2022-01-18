//
//  PhaseType.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation

public protocol PhaseType: DebugText {
  var nextPhase: GamePhasesEnum? { get set }
  var prevPhase: GamePhasesEnum? { get set }
  func process()
  func isDone() -> Bool
  func initialize()
  func cleanup ()
  func moveToPhase(phase: GamePhasesEnum)
}
