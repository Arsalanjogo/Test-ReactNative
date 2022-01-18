//
//  BallPointView.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation
import UIKit

class BallPointView: BallView {
  
  override init(state: BallState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    self.drawPoint(canvas: canvas)
  }
  
  func drawPoint(canvas: UIView) {
    if let state = self.state as? BallState {
      let location: DetectionLocation? = state.getDetectedLocation()
      if location == nil { return }
      DrawingManager.get().drawPoint(view: canvas, point: CGPoint(x: location!.canvasX(canvas: canvas), y: location!.canvasY(canvas: canvas)), with: 2)
    }
  }
  
}
