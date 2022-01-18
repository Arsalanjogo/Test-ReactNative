//
//  GamePhaseDelegate.swift
//  jogo
//
//  Created by Muhammad Nauman on 28/10/2021.
//

import Foundation

protocol GamePhaseDelegate: AnyObject {
  func changePhase(to phase: GamePhasesEnum)
}
