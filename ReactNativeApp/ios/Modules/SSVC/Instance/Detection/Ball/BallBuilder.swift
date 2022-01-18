//
//  BallBuilder.swift
//  jogo
//
//  Created by arham on 04/11/2021.
//

import Foundation


class BallBuilder: SSVCBuilder {
  
  internal static func buildState(modelType: ModelManager.MODELTYPE, exerciseLead: Bool) -> BallState {
    return BallState(modelType: modelType, exerciseLead: exerciseLead, observerId: Football.ObserverID.FOOTBALL.rawValue)
  }
  
  internal static func build(state: BallState) -> BallSSVC<BallState, BallView, BallController> {
    let view = BallPointView(state: state)
    let controller = BallController(state: state)
    return BallSSVC(state: state, stateView: view, controller: controller)
  }
  
  internal static func build(modelType: ModelManager.MODELTYPE, exerciseLead: Bool) -> BallSSVC<BallState, BallView, BallController> {
    let state = buildState(modelType: modelType, exerciseLead: exerciseLead)
    let view = BallPointView(state: state)
    let controller = BallController(state: state)
    return BallSSVC(state: state, stateView: view, controller: controller)
  }
  
}
