//
//  CalibrationVisualsController.swift
//  jogo
//
//  Created by Muhammad Nauman on 16/11/2021.
//

import Foundation

class CalibrationVisualsController: Controller {
  
  var visualState: CalibrationVisualsState!
  
  init(state: CalibrationVisualsState) {
    super.init(state: state)
    visualState = state
  }
  
  func setDelegateToButton(phase: CalibrationPhase, action: Selector) {
    visualState.questionMarkButton?.addTarget(phase, action: action, for: .touchUpInside)
  }
  
}
