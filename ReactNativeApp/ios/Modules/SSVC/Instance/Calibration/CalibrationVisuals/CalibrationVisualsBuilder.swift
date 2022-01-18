//
//  CalibrationVisualsBuilder.swift
//  jogo
//
//  Created by Muhammad Nauman on 16/11/2021.
//

import Foundation

class CalibrationVisualsBuilder: SSVCBuilder {
  
  private static func buildState() -> CalibrationVisualsState {
    return CalibrationVisualsState()
  }
  
  public static func build() -> SSVC<CalibrationVisualsState, CalibrationVisualsView, CalibrationVisualsController> {
    let state = buildState()
    let view = CalibrationVisualsView(state: state)
    let controller = CalibrationVisualsController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
