//
//  BallTrajectoryView.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//


import Foundation
import UIKit

class BallTrajectoryView: BallView {
  
  override init(state: BallState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    self.plotBallTrajectory(canvas: canvas)
  }
  
  func plotBallTrajectory(canvas: UIView) {
    guard let ball = self.state as? BallState else { return }
    let ballLocations: UtilArrayList<DetectionLocation>? = ball.getKnownLastN(locationCount: ball.ballTrajectoryLength)
    if ballLocations == nil { return }
    if ballLocations!.count() == 0 { return }
    let locs: [DetectionLocation] = ballLocations!.get()
    
    if locs.count < 2 { return }
    for i in 0...(locs.count - 2) {
      DrawingManager.get().drawLine(view: canvas,
                                     point1: CGPoint(x: locs[i].getX(), y: locs[i].getY()),
                                     point2: CGPoint(x: locs[i + 1].getX(), y: locs[i + 1].getY()),
                                     color: UIColor.orange)
    }
  }
  
}
