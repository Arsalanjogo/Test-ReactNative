//
//  DynamicSV.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation

public class DynamicSV: UIView, StateViewType, StateObserverType {
  
  
  public func getDebugText() -> String {
    return ""
  }
  
  public var subViewId: String = ""
  public var type: ObserverType = .View
  
  internal var state: State?
  
  init(state: State, frame: CGRect) {
    self.state = state
    super.init(frame: frame)
    self.state!.addObserver(stateObserver: self)
    RenderLoop.addDynamicStateView(dynamicSV: self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func cleanup() {
    self.state = nil
    RenderLoop.removeDynamicStateView(dynamicSV: self)
  }
  
  public func onNotify() {}
  
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
  }
  
  public func draw(canvas: UIView) {}
}
