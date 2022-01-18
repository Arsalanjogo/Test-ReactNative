//
//  LottieRestartButton.swift
//  jogo
//
//  Created by arham on 23/08/2021.
//

import Foundation

class LottieRestartButton: LottieBase<LottieRestartButton> {
  
  init(exerciseVC: ExerciseViewController) {
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Buttons.repeating.rawValue, targetView: exerciseVC.exerciseRenderView.getRestartBtn())
    let _ = try? self.ephemeral(ephemeral: false)
  }
}
