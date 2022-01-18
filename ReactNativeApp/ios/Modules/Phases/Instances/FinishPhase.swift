//
//  FinishPhase.swift
//  jogo
//
//  Created by Mohsin on 24/11/2021.
//

import Foundation

class FinishPhase: Phase {
  
  var ssvc: SSVC<FinishState, FinishView, FinishController>!
  
  override func isDone() -> Bool {
    return self.ssvc.controller.isDone()
  }
  
  override func initialize() {
    super.initialize()
    self.phaseName = "Finish"
    self.nextPhase = .CleanupPhase
    self.prevPhase = .GamePhase
    self.ssvc = FinishBuilder.build()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func cleanup() {
    super.cleanup()
    self.ssvc.cleanup()
    self.ssvc = nil
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
}
