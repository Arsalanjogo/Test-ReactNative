//
//  SensorCalibrationBuilder.swift
//  jogo
//
//  Created by Mohsin on 20/10/2021.
//

import Foundation

public class SensorCalibrationBuilder: SSVCBuilder {
  
  private static func buildState() -> SensorCalibrationState {
    return SensorCalibrationState()
  }
  
  public static func build() -> SSVC<SensorCalibrationState, SensorCalibrationView, SensorCalibrationController> {
    let state = buildState()
    let view = SensorCalibrationView(state: state)
    let controller = SensorCalibrationController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
}
