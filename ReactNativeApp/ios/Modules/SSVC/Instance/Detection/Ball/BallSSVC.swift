//
//  BallSSVC.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation


class BallSSVC<S:BallState, SV: BallView, C: BallController >: SSVC<S, SV, C> {
  
  override init(state: S, stateView: SV, controller: C) {
    super.init(state: state, stateView: stateView, controller: controller)
  }
  
  public func changeView(drawType: BallState.BallDraw) {
    self.removeObserver(observerType: .View)
    var view: DynamicSV
    switch drawType {
    case .RECT:
      view = BallRectView(state: self.getState())
    case .CIRCLE:
      view = BallCircleView(state: self.getState())
    case .POINT:
      view = BallPointView(state: self.getState())
    case .TRAJECTORY:
      view = BallTrajectoryView(state: self.getState())
    }
    self.switchView(view: view as! SV)
  }
}
