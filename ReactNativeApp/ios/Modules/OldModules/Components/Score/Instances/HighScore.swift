//
//  HighScore.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation


class HighScore: BaseScore {
  // Acts the same as te Countdown score but with an added high score functionality.
  internal var highScore: Int = 0
  
  init(baseExercise: BaseExercise, highScore: Int) {
    self.highScore = highScore
    super.init(exercise: baseExercise)
  }
  
  public override func setCount(count: Int, blink: Bool) {
    super.setCount(count: count, blink: blink)
    if count > highScore {
      highScore = count
      // TODO: Display rendering set high score here.
    }
  }
  
  override func getFinalScore() throws -> Int {
    _ = try super.getFinalScore()
    return highScore
  }
  
  public override func start() {
    super.start()
    startNormalTime()
  }
  
  override func reset() {
    super.reset()
  }
}
