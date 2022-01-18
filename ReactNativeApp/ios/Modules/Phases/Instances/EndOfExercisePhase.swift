//
//  SuccessfulPhase.swift
//  Football433
//
//  Created by Muhammad Nauman on 13/12/2021.
//

import Foundation

class EndOfExercisePhase: Phase {
  
  var ssvc: SSVC<EndOfExerciseState, EndOfExerciseView, EndOfExerciseController>!
  
  override func isDone() -> Bool {
    return self.ssvc.controller.isDone()
  }
  
  override func initialize() {
    super.initialize()
    self.phaseName = "EndOfExercise"
    self.nextPhase = .FinishPhase
    self.prevPhase = .CalibrationPhase
    self.ssvc = EndOfExerciseBuilder.build()
    ssvc.controller.setDelegateToButton(phase: self, action: #selector(tryAgainBtnAction(_:)))
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  @objc func tryAgainBtnAction(_ sender: UIButton) {
    self.delegate?.changePhase(to: self.prevPhase!)
  }
  
  public override func cleanup() {
    super.cleanup()
    self.ssvc.cleanup()
    self.ssvc = nil
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
}
