//
//  LottieCounter.swift
//  jogo
//
//  Created by Muhammad Nauman on 22/05/2021.
//

import Foundation

class LottieCounter: LottieBase<LottieCounter> {
  
  init(exerciseVC: ExerciseViewController) {
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Counters.score_2_30.rawValue, targetView: exerciseVC.exerciseRenderView.scoreView.getScoreView())
    _ = try? self.minFrame(minFrame: 3.0).maxFrame(maxFrame: 23.0).ephemeral(ephemeral: false)
  }
  
  func blink() {
    DispatchQueue.main.async {
      _ = try? self.minFrame(minFrame: 40.0).maxFrame(maxFrame: 46.0).play()
    }
  }
}
