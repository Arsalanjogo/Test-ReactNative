//
//  FinishBuilder.swift
//  jogo
//
//  Created by Mohsin on 24/11/2021.
//

import Foundation

public class FinishBuilder: SSVCBuilder {
  
  public static func build() -> SSVC<FinishState, FinishView, FinishController> {
    let state = FinishState()
    let view = FinishView(state: state)
    let controller = FinishController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
