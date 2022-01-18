//
//  MathClip.swift
//  jogo
//
//  Created by arham on 13/09/2021.
//

import Foundation

extension MathUtil {
  
  public static func clip(inside: Double, rad: Double) -> Double {
    return getMin(a: getMax(a: inside, b: 0 + rad), b: 1 - rad)
  }
  
  public static func clip(inside: Double) -> Double {
    return getMin(a: getMax(a: inside, b: 0), b: 1)
  }
  
  public static func clip(inside: Double, max: Double, min: Double) -> Double {
    return getMin(a: getMax(a: inside, b: min), b: max)
  }
}
