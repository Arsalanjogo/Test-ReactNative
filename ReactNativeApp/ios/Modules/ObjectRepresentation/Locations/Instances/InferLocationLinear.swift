//
//  InferLocationLinear.swift
//  jogo
//
//  Created by arham on 05/03/2021.
//

import Foundation

class InferLocationLinear: InferLocation {
  // Calculate all the points between Detected Point 1 and Detected Point n.
  
  // TODO: Can be a simple function instead. Should be static.
  // MARK: Lifecycle and Calculation
  public override func infer(before: UtilArrayList<DetectionLocation>, known: DetectionLocation) {
    var knownBefore: DetectionLocation?
    var unknown: [DetectionLocation] = [DetectionLocation]()
    
    for (index, item) in before.getReversed().enumerated() {
      if before.get()[index].locationKnown() {
        knownBefore = before.get()[index]
        break
      } else {
        unknown.insert(item, at: 0)
      }
    }
    
    if knownBefore == nil || unknown.isEmpty { return }
    
    let centerXStep: Double = (known.getX() - (knownBefore?.getX())!) / (Double(unknown.count + 1))
    let centerYStep: Double = (known.getY() - (knownBefore?.getY())!) / (Double(unknown.count + 1))
    
    let knownBeforeX: Double = knownBefore!.getX()
    let knownBeforeY: Double = knownBefore!.getY()
    
    for (index, item) in unknown.enumerated() {
      item.updateLocation(centerX: knownBeforeX + (centerXStep * Double((index + 1))),
                          centerY: knownBeforeY + (centerYStep * Double((index + 1))),
                          status: DetectionLocation.STATUS.INFERRED)
    }
  }
 
}
