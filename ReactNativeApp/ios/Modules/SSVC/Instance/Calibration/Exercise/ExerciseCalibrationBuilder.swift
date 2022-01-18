//
//  ExerciseCalibrationBuilder.swift
//  jogo
//
//  Created by Mohsin on 21/10/2021.
//

import Foundation

public class ExerciseCalibrationBuilder: SSVCBuilder {
  
  private static func buildState() -> ExerciseCalibrationState {
    return ExerciseCalibrationState()
  }
  
  public static func build() -> SSVC<ExerciseCalibrationState, ExerciseCalibrationView, ExerciseCalibrationController> {
    let state = buildState()
    let view = ExerciseCalibrationView(state: state)
    let controller = ExerciseCalibrationController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
}
