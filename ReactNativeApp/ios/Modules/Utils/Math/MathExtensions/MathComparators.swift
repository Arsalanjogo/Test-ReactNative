//
//  MathComparators.swift
//  jogo
//
//  Created by arham on 13/09/2021.
//

import Foundation

extension MathUtil {

  // MARK: Common Max and Min.
  public static func getCompared(a: DetectionLocation, b: DetectionLocation, axis: Axis, comparator: Comparators) -> Double {
    switch comparator {
    case .max:
      return getMax(a: a, b: b, axis: axis)
    case .min:
      return getMin(a: a, b: b, axis: axis)
    }
  }
  
  public static func getCompared(a: ObjectDetection, b: ObjectDetection, axis: Axis, comparator: Comparators) -> Double {
    switch comparator {
    case .max:
      return getMax(a: a, b: b, axis: axis)
    case .min:
      return getMin(a: a, b: b, axis: axis)
    }
  }

  // MARK: Get larger of the 2 points.
  
  public static func getMax(a: Double, b: Double) -> Double {
    return max(a, b)
  }
  
  public static func getMax(a: DetectionLocation, b: DetectionLocation, axis: Axis) -> Double {
    switch axis {
    case .x:
      return getMax(a: a.getX(), b: b.getX())
    case .y:
      return getMax(a: a.getY(), b: b.getY())
    case .z:
      return getMax(a: a.getZ(), b: b.getZ())
    }
  }
  
  public static func getMax(a: ObjectDetection, b: ObjectDetection, axis: Axis) -> Double {
    return getMax(a: a.getDetectedLocation()!, b: b.getDetectedLocation()!, axis: axis)
  }
  
  // MARK: Get Smaller of the 2 points.
  
  public static func getMin(a: Double, b: Double) -> Double {
    return min(a, b)
  }
  
  public static func getMin(a: DetectionLocation, b: DetectionLocation, axis: Axis) -> Double {
    switch axis {
    case .x:
      return getMin(a: a.getX(), b: b.getX())
    case .y:
      return getMin(a: a.getY(), b: b.getY())
    case .z:
      return getMin(a: a.getZ(), b: b.getZ())
    }
  }
  
  public static func getMin(a: ObjectDetection, b: ObjectDetection, axis: Axis) -> Double {
    return getMin(a: a.getDetectedLocation()!, b: b.getDetectedLocation()!, axis: axis)
  }
  
}
