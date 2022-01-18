//
//  CountdownScore.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation


class CountdownScore: BaseScore {
  // Score is used when the timer counts down from n seconds.
  // Stops the exercise when the time reaches zero.
  // Time goes down.
  var time: Double
  var currentTime: Double = 0
  var finalTime: Double
  
  public init(baseExercise: BaseExercise, time: Double) {
    self.time = time
    self.finalTime = time/1000
    super.init(exercise: baseExercise)
    self.countdown = true
  }
  
  public override func start() {
    super.start()
    startCountdownTime(time: Int(time))
//    if Double(self.exerciseRenderModule!.getCountUpSeconds()!*1000) >= self.time {
//      DispatchQueue.main.async {
//        self.stopExercise()
//      }
//    }
  }
  
  override func reset() {
    super.reset()
  }
}
