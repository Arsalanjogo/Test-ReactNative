//
//  AnswerMovement.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

public protocol AnswerMovement {
  func update(x: Double, y: Double) -> (Double, Double)
}
