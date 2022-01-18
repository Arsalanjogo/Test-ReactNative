//
//  PointsBuilder.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation

public class PointsBuilder: SSVCBuilder {
  
  private static func buildState() -> PointsState {
    return PointsState()
  }
  
  public static func buildSquared() ->
  SSVC<PointsState, SquaredPointsView, PointsController> {
      
    let state = buildState()
    let squaredPointsView = SquaredPointsView(state: state)
    let pointsController = PointsController(state: state)
    return SSVC(state: state, stateView: squaredPointsView, controller: pointsController)
  }
}
