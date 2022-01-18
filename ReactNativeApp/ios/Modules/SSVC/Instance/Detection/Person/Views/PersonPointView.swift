//
//  PersonPointView.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation
import UIKit

public class PersonPointView: PersonView {
  
  override init(state: PersonState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    guard let state = self.state as? PersonState else { return }
    state.bodyParts.forEach({ drawPointsDebug(canvas: canvas, location: $0.getLocation()!)})
  }
  
  func drawPointsDebug(canvas: UIView, location: DetectionLocation) {
    
    if !location.locationKnown() { return }
    
    DrawingManager.get().drawPoint(
      view: canvas,
      point: CGPoint(
        x: location.getX(),
        y: location.getY()
      ),
      with: CGFloat(5.0),
      color: .red
    )
  }
}
