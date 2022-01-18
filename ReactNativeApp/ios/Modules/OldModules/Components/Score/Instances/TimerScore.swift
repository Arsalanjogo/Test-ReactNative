//
//  TimerScore.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation

class TimerScore: BaseScore {
  // Score is used when the timer counts down from n seconds.
  // Stops the exercise when the time reaches zero.
  // Time goes up.
  private var time: Double
  var currentTime: Double = 0
  var finalTime: Double
  
  init(baseExercise: BaseExercise, time: Double) {
    self.time = time
    self.finalTime = time/1000
    super.init(exercise: baseExercise)
    self.exerciseRenderModule?.hideScore()
  }
  
  public override func start() {
    super.start()
  }
  
  public override func stopTime() {
    super.stopTime()
  }
  
  public override func startCountdownTime(time: Int, firstTime: Bool = true) {
    super.startCountdownTime(time: time, firstTime: firstTime)
//    self.currentTime = 0
//    if Double(self.exerciseRenderModule!.getCountUpSeconds()!*1000) >= self.time {
//      DispatchQueue.main.async {
//        self.stopExercise()
//      }
//    }
  }
  
  public override func startNormalTime() {
    super.startNormalTime()
//    self.currentTime = 0
//    if Double(self.exerciseRenderModule!.getCountUpSeconds()!*1000) >= self.time {
//      DispatchQueue.main.async {
//        self.stopExercise()
//      }
//    }
  }
  
}
