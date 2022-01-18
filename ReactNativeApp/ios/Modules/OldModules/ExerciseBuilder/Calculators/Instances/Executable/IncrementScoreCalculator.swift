//
//  IncrementScoreCalculator.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation

class IncrementScoreCalculator: ExecutableCalculatorProtocol {
  
  private var amount: Int
  private var blink: Bool
  private var bleep: Bool
  
  init(val: onState) throws {
    amount = val.amount ?? 0
    blink = val.blink ?? false
    bleep = val.bleep ?? false
  }
  
  
  func execute() throws {
    BaseExercise.baseExercise?.score?.incrementCount(amount: amount, blink: blink, beep: bleep)
  }
  
  func debugString() -> String {
    ""
  }
  
}
