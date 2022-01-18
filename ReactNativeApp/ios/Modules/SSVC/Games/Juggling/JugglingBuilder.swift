//
//  JugglingBuilder.swift
//  jogo
//
//  Created by arham on 18/11/2021.
//

import Foundation

class JugglingBuilder: SSVCBuilder {
  
  internal static func buildState() -> JugglingState {
    return JugglingState()
  }
  
  internal static func build(ballController: BallController?,
                             personController: PersonController?,
                             pointController: PointsController?) -> SSVC<JugglingState, JugglingView, JugglingController> {
    let state = self.buildState()
    let view = JugglingView(state: state)
    let controller = JugglingController(state: state,
                                        ballController: ballController,
                                        personController: personController,
                                        pointController: pointController)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
