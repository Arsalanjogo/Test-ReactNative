//
//  MathAvg.swift
//  jogo
//
//  Created by arham on 13/09/2021.
//

import Foundation

extension MathUtil {

  public static func getMean(a: Double, b: Double) -> Double {
    return (a + b) / 2
  }
  
  public static func getMean(a: DetectionLocation, b: DetectionLocation, axis: Axis) -> Double {
    switch axis {
    case .x:
      return getMean(a: a.getX(), b: b.getX())
    case .y:
      return getMean(a: a.getY(), b: b.getY())
    case .z:
      return getMean(a: a.getZ(), b: b.getZ())
    }
  }
  
  public static func getMean(a: ObjectDetection, b: ObjectDetection, axis: Axis) -> Double {
    return getMean(
      a: a.getDetectedLocation() ?? DetectionLocation(label: a.label, centerX: 0, centerY: 0, frameId: a.getDetectedLocation()?.frameId ?? -1, confidence: 0, status: .MISSING),
      b: b.getDetectedLocation() ?? DetectionLocation(label: b.label, centerX: 0, centerY: 0, frameId: b.getDetectedLocation()?.frameId ?? -1, confidence: 0, status: .MISSING),
      axis: axis)
  }

}
