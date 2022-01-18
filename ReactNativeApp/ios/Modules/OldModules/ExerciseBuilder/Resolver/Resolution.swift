//
//  Resolution.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation



class Resolution: CanDraw {
  
  private var predicateCalculator: Array<PredicateCalculatorProtocol> = Array<PredicateCalculatorProtocol>()
  
  init(val: [resState]) {
    val.forEach { rState in
      do {
        let rVal: PredicateCalculatorProtocol = try PredicateFactory.build(val: rState)
        predicateCalculator.append(rVal)
      } catch {
        Logger.shared.log(logType: .ERROR, message: "Unable to create the Predicate for this resolution.")
      }
    }
  }
  
  public func checkResolution() -> Bool {
    let val: Bool = predicateCalculator.allSatisfy { rVal in
      rVal.match()
    }
    return val
  }
  
  func draw(canvas: UIView) {
    
  }
  
  func drawDebug(canvas: UIView) {
    predicateCalculator.forEach { pVal in
      DrawingManager.get().drawText(view: canvas, origin: nil, label:  pVal.debugString())
    }
  }

}
