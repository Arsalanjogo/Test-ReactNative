//
//  SuccessfulBuilder.swift
//  Football433
//
//  Created by Muhammad Nauman on 13/12/2021.
//

import Foundation

public class EndOfExerciseBuilder: SSVCBuilder {
  
  public static func build() -> SSVC<EndOfExerciseState, EndOfExerciseView, EndOfExerciseController> {
    let state = EndOfExerciseState()
    let view = EndOfExerciseView(state: state)
    let controller = EndOfExerciseController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
