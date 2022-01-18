//
//  MathUtil.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation

class MathUtil {
  // Provides operations for angle calculations, comparators in the x and y axis
  // and more.
  
  // If the angles are outside the normal degree range, it will be bad so do all
  // comparisons between 0 and 360.
  
  // MARK: Utility functionality
  public enum BadAngleOutput: Double {
    case nul = 361.0
    case sim = -1.0
  }
  
  public enum Axis: Int {
    case x = 0
    case y = 1
    case z = 2
  }
  
  public enum Comparators: Int {
    case max = 0
    case min = 1
  }
  
  public static func radianToDegrees(value: Double) -> Double {
    return value * (180.0 / Double.pi)
  }
  
  public static func degreesToRadian(value: Double) -> Double {
    return value * (Double.pi / 180.0)
  }
  
 }
