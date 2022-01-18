//
//  SSVC.swift
//  jogo
//
//  Created by Mohsin on 12/10/2021.
//

import Foundation

public class SSVC<S: State, SV: StateViewType, C: Controller>: DebugText {
  private let state: S
  private var stateView: SV?
  internal let controller: C
  
  init(state: S, stateView: SV, controller: C) {
    self.state = state
    self.stateView = stateView
    self.controller = controller
  }
  
  public func cleanup(with state: Bool = true) {
    stateView?.cleanup()
    if state { self.state.cleanup() }
    self.controller.cleanup()
  }
  
  private func removeView() {
    self.stateView?.cleanup()
    self.stateView = nil
  }
  
  // TODO: Need to change the access modifier for this removeObserver function.
  public func removeObserver(observerType: ObserverType = .View) {
    self.state.removeObserver(observerType: observerType)
  }
  
  private func setView(view: SV) {
    self.stateView = view
  }
  
  internal func switchView(view: SV) {
    self.removeView()
    self.setView(view: view)
  }
  
  public func getState() -> S {
    return self.state
  }
  
  // MARK: Debug Text
  public func getDebugText() -> String {
    return """
      state: \(state.getDebugText())
      stateview: \(stateView?.getDebugText() ?? "nil")
      controller: \(controller.getDebugText())
    """
  }
  
}
