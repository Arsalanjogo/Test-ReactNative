//
//  InfiniteScore.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation


class InfiniteScore: BaseScore {
  // Only stop the exercise when the user presses the stop button externally.
  
  init(baseExercise: BaseExercise) {
    super.init(exercise: baseExercise)
  }
  
  public override func start() {
    super.start()
    startNormalTime()
  }
}
