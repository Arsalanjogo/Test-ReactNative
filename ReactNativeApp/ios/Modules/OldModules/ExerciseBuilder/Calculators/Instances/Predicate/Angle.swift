//
//  Angle.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation

class Angle: PredicateCalculatorProtocol {
  
  private final var l1: MovingObject?
  private final var l2: MovingObject?
  private final var l3: MovingObject?
  private final var minAngle: Double
  private final var maxAngle: Double
  
  init(val: resState) throws {
    l1 = try IResolve.resolve(val: val.i1)
    l2 = try IResolve.resolve(val: val.i2)
    l3 = try IResolve.resolve(val: val.i3)
    minAngle = Double(val.minAngle)
    maxAngle = Double(val.maxAngle)
  }
  
  func match() -> Bool {
    if (l1 == nil || l2 == nil || l3 == nil) { return false }
    let angle: Double = MathUtil.calculateAngle3Points(pA: l1!, pB: l2!, pC: l3!, negativeAngle: false)
    let val: Bool =  (angle > minAngle || minAngle == -1) && (angle < maxAngle || maxAngle == -1)
    return val
  }
  
  
  func debugString() -> String {
    if l1 == nil || l2 == nil || l3 == nil {
      return ""
    }
    return "\(l1!.getLabel()), \(l2!.getLabel()), \(l3!.getLabel()) :  \(MathUtil.calculateAngle3Points(pA: l1!, pB: l2!, pC: l3!, negativeAngle: false)) = \(match())"
  }
  
}
