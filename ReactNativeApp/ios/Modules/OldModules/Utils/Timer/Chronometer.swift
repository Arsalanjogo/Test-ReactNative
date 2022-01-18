//
//  Chronometer.swift
//  jogo
//
//  Created by Muhammad Nauman on 31/03/2021.
//

import UIKit

class Chronometer: UILabel {
  // Provides timer functionality for the Timer in the score module.
  
  private var timer: Timer?
  private var time: Int?
  private var seconds = 0
  private var isCountDown = false

  var tick: (() -> Void)?

  private var started = false

  func setTime(time: Int, isCountDown: Bool) {
    self.time = time / 1000
    self.text = "00:00"
    self.isCountDown = isCountDown
  }
  
  func start(firstTime: Bool = true) {
    if started { return }
    if firstTime { seconds = 0 }
    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    self.started = true
  }
  
  @objc func timerTick() {
    seconds += 1
    tick?()
    if isCountDown {
      if seconds <= time! {
        let mins = (time! - seconds) / 60
        let secs = (time! - seconds) % 60
        self.text = String(format: "%02i:%02i", mins, secs)
      } else {
        self.stop()
      }
    } else {
      let mins = seconds / 60
      let secs = seconds % 60
      self.text = String(format: "%02i:%02i", mins, secs)
    }
  }
  
  func pause() {
    self.started = false
    timer?.invalidate()
    timer = nil
  }
  
  func stop() {
    self.started = false
    seconds = 0
    timer?.invalidate()
    timer = nil
    self.text = "00:00"
  }
  
  func getSeconds() -> Int {
    return seconds
  }

}
