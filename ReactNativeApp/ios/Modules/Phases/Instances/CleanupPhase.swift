//
//  CleanupPhase.swift
//  jogo
//
//  Created by Mohsin on 29/11/2021.
//

import Foundation

class CleanupPhase: Phase {
  
  private var isCleanupDone = false
  
  override func isDone() -> Bool {
    return self.isCleanupDone
  }
  
  override func initialize() {
    super.initialize()
    self.phaseName = "Cleanup"
    self.nextPhase = nil
    self.prevPhase = .FinishPhase
    
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)",
                               delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  override func process() {
    GameContext.getContext()?.cleanup()
    Profiler.get().saveProfile()
    Logger.shared.clearMaps()
    self.isCleanupDone = true
  }
  
  public override func cleanup() {
    super.cleanup()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
}
