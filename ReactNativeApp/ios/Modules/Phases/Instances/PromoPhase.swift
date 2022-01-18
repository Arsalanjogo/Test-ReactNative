//
//  PromoPhase.swift
//  jogo
//
//  Created by Muhammad Nauman on 08/11/2021.
//

import Foundation

class PromoPhase: Phase {
  
  var promo: SSVC<PromoState, PromoView, PromoController>?
  
  override func process() { }
  
  override func isDone() -> Bool {
    return (self.promo?.controller.isDone() ?? false)
  }
  
  override func initialize() {
    super.initialize()
    self.phaseName = "Promo"
    self.nextPhase = .CalibrationPhase
    self.prevPhase = .VideoPhase
    self.promo = PromoBuilder.build()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func cleanup() {
    super.cleanup()
    self.promo?.cleanup()
    self.promo = nil
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
}
