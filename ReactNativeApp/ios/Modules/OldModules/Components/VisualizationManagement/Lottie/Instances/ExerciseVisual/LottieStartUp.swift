//
//  LottieStartUp.swift
//  jogo
//
//  Created by arham on 03/09/2021.
//

import Foundation
import Lottie


class LottieStartUp: LottieBase<LottieStartUp> {
  
  init(exerciseVC: ExerciseViewController) {
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Opening.gen_text_alpha.rawValue, targetView: nil)
    _ = try? self.scale(x: 1.0, y: 1.0).move(x: 0.5, y: 0.5).contentMode(mode: .scaleAspectFit)
  }
  
  override func play() {
    _ = try? self.play(completion: {
      BaseExercise.baseExercise?.status = .CALIBRATION
    })
  }
}
