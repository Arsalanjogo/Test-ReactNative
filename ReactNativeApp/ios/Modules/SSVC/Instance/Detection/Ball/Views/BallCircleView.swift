//
//  BallCircleView.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation
import UIKit

class BallCircleView: BallView {
  
  override init(state: BallState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    self.drawCircle(canvas: canvas)
  }
  
  func drawCircle(canvas: UIView) {
    if let state = self.state as? BallState {
      let location: DetectionLocation? = state.getDetectedLocation()
      if location == nil { return }
      let minLength = Double(min(canvas.frame.width, canvas.frame.height))
      if (state.getRadius() * minLength) > (0.5 * minLength) { return }
      DrawingManager.get().drawCircle(view: canvas,
                                       center: CGPoint(x: location!.getX(), y: location!.getY()),
                                       with: CGFloat(state.getRadius() / 2), color: state.isCalibrated ? ThemeManager.shared.theme.primaryColor : .red, hollow: true)
    }
  }
  
}
