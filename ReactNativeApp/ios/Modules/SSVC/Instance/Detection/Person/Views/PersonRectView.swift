//
//  PersonRectView.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation
import UIKit

public class PersonRectView: PersonView {
  
  override init(state: PersonState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    guard let state = self.state as? PersonState else { return }
    drawPersonBB(canvas: canvas, state: state, color: state.isCalibrated ? ThemeManager.shared.theme.primaryColor : .red)
  }
  
  func drawPersonBB(canvas: UIView, state: PersonState, color: UIColor) {
    let lastLocations = state.getDetectionSubClasses().filter { d in
      // @TODO: This gets us the last detected location instead. From the last 100 detections which is kinda bad to be honest.
      // return d.getDetectedLocation() != nil
      
      /// This should remove nil error. Does swift not do the conditional chaining thingy where if the first condition is false, the rest are not calculated if its an and??
      let det = d.getLocation()
      if det == nil { return false }
      return det!.getStatus() == .DETECTED
    }
    guard !lastLocations.isEmpty else { return }
    let minX = lastLocations.min { d1, d2 in
      return d1.getX()! < d2.getX()!
    }?.getX()
    let minY = lastLocations.min { d1, d2 in
      return d1.getY()! < d2.getY()!
    }?.getY()
    let maxX = lastLocations.max { d1, d2 in
      return d1.getX()! < d2.getX()!
    }?.getX()
    let maxY = lastLocations.max { d1, d2 in
      return d1.getY()! < d2.getY()!
    }?.getY()
    let width = 1.4 * (maxX!-minX!)
    DrawingManager.get().drawHollowRect(view: canvas,
                                         rect: CGRect(x: minX! - (0.2 * width), y: minY!, width: width, height: maxY! - minY!),
                                         color: color.withAlphaComponent(0.6),
                                         borderWidth: 5.0)
  }
}
