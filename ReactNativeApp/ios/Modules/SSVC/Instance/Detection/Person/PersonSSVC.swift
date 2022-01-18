//
//  PersonSSVC.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation


class PersonSSVC<S:PersonState, SV: PersonView, C: PersonController >: SSVC<S, SV, C> {
  
  override init(state: S, stateView: SV, controller: C) {
    super.init(state: state, stateView: stateView, controller: controller)
  }
  
  public func changeView(drawType: PersonState.PersonDraw) {
    self.removeObserver(observerType: .View)
    var view: PersonView
    switch drawType {
    case .RECT:
      view = PersonRectView(state: self.getState())
    case .POINTS:
      view = PersonPointView(state: self.getState())
    case .SKELETON:
      view = PersonSkeletonView(state: self.getState())
    }
    self.switchView(view: view as! SV)
  }
}
