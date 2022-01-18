//
//  TillFailureScore.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation


class TillFailureScore: BaseScore {
  // Perform till you fail a repetition.
  
  init(baseExercise: BaseExercise) {
    super.init(exercise: baseExercise)
  }
  
  public override func start() {
    super.start()
    startNormalTime()
  }
  
  public override func resetCount() {
    DispatchQueue.main.async {
      self.stopExercise()
    }
  }
  
}
