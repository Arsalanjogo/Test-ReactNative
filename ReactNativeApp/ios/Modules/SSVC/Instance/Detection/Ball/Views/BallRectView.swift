//
//  BallRectView.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//


import Foundation
import UIKit

class BallRectView: BallView {
  
  override init(state: BallState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    self.drawRect(canvas: canvas)
  }
  
  func drawRect(canvas: UIView) {
    if let state = self.state as? BallState {
      let location: DetectionLocation? = state.getDetectedLocation()
      if location == nil { return }
      let rad: CGFloat = CGFloat(location!.getRadius())
      let radX: CGFloat = (min(canvas.frame.height, canvas.frame.width) / canvas.frame.width) * rad
      let radY: CGFloat = (min(canvas.frame.height, canvas.frame.width) / canvas.frame.height) * rad
      let x1: CGFloat = CGFloat(location!.getX())
      let y1: CGFloat = CGFloat(location!.getY())
      DrawingManager.get().drawHollowRect(view: canvas,
                                           rect: CGRect(x: x1,
                                                        y: y1,
                                                        width: radX,
                                                        height: radY))
    }
  }
}

