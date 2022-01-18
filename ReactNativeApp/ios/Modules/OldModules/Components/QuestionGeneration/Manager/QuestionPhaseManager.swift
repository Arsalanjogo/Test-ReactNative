//
//  QuestionPhaseManager.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation


class QuestionPhaseManager {
  
  var phaseMap: [PhaseA: PhaseA] = [PhaseA: PhaseA]()
  var currentPhase: PhaseA?
  
  public func map(from: PhaseA, to: PhaseA) -> QuestionPhaseManager {
    if (phaseMap[from]) != nil { } else {
      phaseMap[from] = to
    }
    return self
  }
  
  public func start(phase: PhaseA) {
    if phaseMap[phase] != nil {
      if currentPhase != nil { currentPhase?.stop() }
      currentPhase = phase
      currentPhase?.start()
    }
  }
  
  public func next() {
    self.start(phase: self.phaseMap[self.currentPhase!]!)
  }
  
  public func draw(canvas: UIView) {
    currentPhase?.draw(canvas: canvas)
    
  }
  
  public func drawDebug(canvas: UIView) {
    currentPhase?.drawDebug(canvas: canvas)
  }
  
  public func process() {
    currentPhase?.process()
    if currentPhase?.phaseFinished() ?? false {
      self.next()
    }
  }
  
  public func stop() {
    self.phaseMap.removeAll()
    self.currentPhase = nil
  }
  
}
