//
//  SuccessfulController.swift
//  Football433
//
//  Created by Muhammad Nauman on 14/12/2021.
//

import Foundation

public class EndOfExerciseController: Controller {
  
  init(state: EndOfExerciseState) {
    super.init(state: state)
  }
  
  func isDone() -> Bool {
    return (self.state as? EndOfExerciseState)?.isEnded ?? false
  }
  
  func setDelegateToButton(phase: EndOfExercisePhase, action: Selector) {
    (self.state as? EndOfExerciseState)?.tryAgainButton?.addTarget(phase, action: action, for: .touchUpInside)
  }
  
}
