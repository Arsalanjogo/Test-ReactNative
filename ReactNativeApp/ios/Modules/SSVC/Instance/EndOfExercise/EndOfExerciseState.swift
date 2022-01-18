//
//  SuccessfulState.swift
//  Football433
//
//  Created by Muhammad Nauman on 13/12/2021.
//

import Foundation

public class EndOfExerciseState: State {
  
  var isEnded = false
  var timer: Timer?
  var seconds = 0
  //TODO: Need to discuss this openly for communication in SSVC
  var tryAgainButton: UIButton?
  
  override init() {
    super.init()
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
  }
  
  @objc private func timerTick() {
    let maxTime = 10
    if seconds < maxTime {
      seconds += 1
      self.tryAgainButton?.setTitle("Play Again (\(maxTime-seconds))", for: .normal)
    } else {
      isEnded = true
      timer?.invalidate()
      timer = nil
    }
  }
  
  public override func cleanup() {
    self.timer?.invalidate()
    self.tryAgainButton = nil
    super.cleanup()
  }
  
}
