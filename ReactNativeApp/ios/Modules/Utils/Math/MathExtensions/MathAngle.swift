//
//  Math3PointAngle.swift
//  jogo
//
//  Created by arham on 13/09/2021.
//

import Foundation

extension MathUtil {
  
  public static func calculateAngle3Points(pA: DetectionLocation?,
                                           pB: DetectionLocation?,
                                           pC: DetectionLocation?,
                                           negativeAngle: Bool) -> Double {
    if pA == nil || pB == nil || pC == nil {
      return BadAngleOutput.nul.rawValue
    }
    let dA: Double = pC?.getEuclideanDistance(location: pB) ?? -1
    let dB: Double = pC?.getEuclideanDistance(location: pA) ?? -1
    let dC: Double = pA?.getEuclideanDistance(location: pB) ?? -1
    if dA == -1 || dB == -1 || dC == -1 {
      return BadAngleOutput.nul.rawValue
    }
    let dA2: Double = pow(dA, 2)
    let dB2: Double = pow(dB, 2)
    let dC2: Double = pow(dC, 2)
    let d2CA: Double = 2 * dC * dA
    
    let thetha: Double = acos((dA2 + dC2 - dB2) / d2CA)
    if negativeAngle {
      return ceil(180.0 - radianToDegrees(value: thetha))
    }
    return ceil(radianToDegrees(value: thetha))
  }
  
  public static func calculateAngle3Points(pA: ObjectDetection, pB: ObjectDetection, pC: ObjectDetection, negativeAngle: Bool) -> Double {
    return MathUtil.calculateAngle3Points(pA: pA.getDetectedLocation(), pB: pB.getDetectedLocation(), pC: pC.getDetectedLocation(), negativeAngle: negativeAngle)
  }
  
  public static func calculateAngle3Points(pA: MovingObject, pB: MovingObject, pC: MovingObject, negativeAngle: Bool) -> Double {
      return MathUtil.calculateAngle3Points(pA: pA.getLocation(), pB: pB.getLocation(), pC: pC.getLocation(), negativeAngle: negativeAngle)
    }
  
  public static func calculateSlopeWithXAxis(x1: Double, x2: Double, y1: Double, y2: Double) -> Double {
    return abs((y2 - y1) / (x2 - x1))
  }
  
  public static func calculateSlopeWithXAxis(o1: ObjectDetection, o2: ObjectDetection) -> Double {
    return abs((o2.getY()! - o1.getY()!) / (o2.getX()! - o1.getX()!))
  }
  
  public static func calculateAngleWithXAxis(o1: ObjectDetection, o2: ObjectDetection) -> Double {
    return calculateAngleWithXAxis(loc1: o1.getDetectedLocation()!, loc2: o2.getDetectedLocation()!)
  }
  
  public static func calculateAngleWithXAxis(loc1: DetectionLocation, loc2: DetectionLocation) -> Double {
    return calculateAngleWithXAxis(x1: loc1.getX(), y1: loc1.getY(), x2: loc2.getX(), y2: loc2.getY())
    
  }
  
  public static func calculateAngleWithXAxis(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    return round(
      radianToDegrees(value:
                        atan(
                          calculateSlopeWithXAxis(x1: x1, x2: x2, y1: y1, y2: y2))
      ) * 100.0
    ) / 100.0
  }
  
  public static func calculateAngleWithYAxis(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    return abs(
      90 - round(
      radianToDegrees(value:
                        atan(
                          calculateSlopeWithXAxis(x1: x1, x2: x2, y1: y1, y2: y2))
      ) * 100.0
    ) / 100.0
    )
  }
  
  public static func calculateAngleWithYAxis(loc1: DetectionLocation, loc2: DetectionLocation) -> Double {
    return calculateAngleWithYAxis(x1: loc1.getX(), y1: loc1.getY(), x2: loc2.getX(), y2: loc2.getY())
    
  }
  
  public static func calculateAngleWithYAxis(o1: ObjectDetection, o2: ObjectDetection) -> Double {
    return calculateAngleWithYAxis(loc1: o1.getDetectedLocation()!, loc2: o2.getDetectedLocation()!)
  }
  
}
