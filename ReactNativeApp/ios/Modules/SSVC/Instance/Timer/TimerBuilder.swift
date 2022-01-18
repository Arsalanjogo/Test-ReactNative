//
//  TimerBuilder.swift
//  jogo
//
//  Created by Mohsin on 27/10/2021.
//

import Foundation

public class TimerBuilder: SSVCBuilder {
  
  public static func build() -> SSVC<TimerState, TimerView, TimerController> {
    let state = TimerState()
    let view = TimerView(state: state)
    let controller = TimerController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
}
