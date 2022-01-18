//
//  StopRestartBuilder.swift
//  Football433
//
//  Created by Muhammad Nauman on 15/12/2021.
//

import Foundation

public class StopRestartBuilder: SSVCBuilder {
  
  public static func build() -> SSVC<StopRestartState, StopRestartView, StopRestartController> {
    let state = StopRestartState()
    let view = StopRestartView(state: state)
    let controller = StopRestartController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
