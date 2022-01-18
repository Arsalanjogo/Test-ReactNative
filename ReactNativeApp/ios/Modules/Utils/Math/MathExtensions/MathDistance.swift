//
//  MathDistance.swift
//  jogo
//
//  Created by arham on 13/09/2021.
//

import Foundation

extension MathUtil {
  
  public static func getDistance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    let xDist: Double = abs(x2 - x1)
    let yDist: Double = abs(y2 - y1)
    let distanceSqr: Double = pow(xDist, 2) + pow(yDist, 2)
    return sqrt(distanceSqr)
  }
  
  public static func getDistance(a: DetectionLocation, b: DetectionLocation) -> Double {
    return self.getDistance(x1: a.getX(), y1: a.getY(), x2: b.getX(), y2: b.getY())
  }
  
  public static func getDistance(a: ObjectDetection, b: ObjectDetection) -> Double {
    return self.getDistance(a: a.getDetectedLocation()!, b: b.getDetectedLocation()!)
  }
  
}
