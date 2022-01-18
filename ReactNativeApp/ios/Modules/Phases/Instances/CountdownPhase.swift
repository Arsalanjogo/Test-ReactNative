//
//  CountdownPhase.swift
//  jogo
//
//  Created by Mohsin on 12/11/2021.
//

import Foundation

class CountdownPhase: Phase {
  
  var ssvc: SSVC<CountdownState, CountdownView, CountdownController>?
  
  override func process() {
    
  }
  
  override func isDone() -> Bool {
    return (self.ssvc?.controller.isDone() ?? false)
  }
  
  override func initialize() {
    self.phaseName = "Countdown"
    self.nextPhase = .GamePhase
    self.prevPhase = .CalibrationPhase
    self.ssvc = CountdownBuilder.build()
    super.initialize()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func cleanup() {
    super.cleanup()
    self.ssvc?.cleanup()
    self.ssvc = nil
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
}
