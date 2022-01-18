//
//  LottieHiddenStopButton.swift
//  jogo
//
//  Created by arham on 23/08/2021.
//

import Foundation

class LottieHiddenStopButton: LottieBase<LottieHiddenStopButton> {
  
  init(exerciseVC: ExerciseViewController) {
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Buttons.home.rawValue, targetView: exerciseVC.exerciseRenderView.getStopBtn())
    let _ = try? self.ephemeral(ephemeral: false)
  }
}
