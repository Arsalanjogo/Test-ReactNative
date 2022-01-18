//
//  LayoutSV.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation
import UIKit


public class LayoutSV: UIView, StateViewType, StateObserverType {
  
  public func getDebugText() -> String {
    return ""
  }
  
  public static func == (lhs: LayoutSV, rhs: LayoutSV) -> Bool {
    return lhs.subViewId == rhs.subViewId
  }

//  public func hash(into hasher: inout Hasher) {
//    hasher.combine(subViewId)
//  }
  
  public var subViewId: String = ""
  public var type: ObserverType = .View
  public var animationOverlay: AnimationOverlay!

  internal var state: State?
  
  init(state: State, frame: CGRect) {
    subViewId = UUID().uuidString
    self.state = state
    super.init(frame: frame)
    self.animationOverlay = RenderLoop.getSpriteScene()//AnimationOverlay(size: bounds.size, prepareAnimation: prepareAnimation)
//    RenderLoop.assignNewScene(skScene: animationOverlay)
    self.prepareAnimation()
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
    self.state!.addObserver(stateObserver: self)
    // TODO: Add the logic for the static and dynamic SVs to be added into their respective arrays.
//    RenderLoop.addLayoutStateView(layoutSV: self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func prepareAnimation() {
    
  }
  
  public func cleanup() {
    self.state = nil
    RenderLoop.removeLayoutStateView(layoutSV: self)
//    RenderLoop.removeCurrentScene()
  }
  
  public func onNotify() {}
  
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
  }
  
  public func draw(canvas: UIView) {}
}
