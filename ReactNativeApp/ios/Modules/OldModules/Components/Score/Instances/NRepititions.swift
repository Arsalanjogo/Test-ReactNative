//
//  NRepititions.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation


class NRepititions: BaseScore {
  // Exits the exercise when the person reaches the repetition counts.
  
  final var repititons: Int
  
  init(baseExercise: BaseExercise, reptitions: Int) {
    self.repititons = reptitions
    super.init(exercise: baseExercise)
  }
  
  public override func start() {
    super.start()
    SpeechManager.get().talk(sentence: "Perform \(self.repititons) \(BaseExercise.getName())")
    startNormalTime()
  }
  
  public override func setCount(count: Int, blink: Bool) {
    super.setCount(count: count, blink: blink)
    if count == repititons {
      DispatchQueue.main.async {
        self.stopExercise()
      }
    }
  }
  
  
  
  
}
